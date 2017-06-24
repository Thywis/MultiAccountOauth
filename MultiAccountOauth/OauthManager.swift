//
//  GoogleOauthManager.swift
//  PickedMail
//
//  Created by Kedan Li on 2017/6/17.
//  Copyright © 2017年 Li Kedan. All rights reserved.
//

import AppAuth
import SwiftyJSON

public class OauthManager: DynamicStorage {

    public static let sharedInstance = OauthManager()
    
    public var cliendId = ""
    public var scope = [String]()
    public var urlScheme = ""
    public var serverClientId: String?
    
    public var authenticatedUsers = [GoogleUserInstance]()
    
    public var oauthSession: OIDAuthorizationFlowSession?

    dynamic var signinUsersRefreshToken = [String: String]()
    
    public func configure(cliendId: String, scope: [String], urlScheme: String, serverCliendId: String?) {
        self.cliendId = cliendId
        self.scope = scope
        if scope.contains("profile") == false {
            self.scope.append("profile")
        }
        if scope.contains("openid") == false {
            self.scope.append("openid")
        }
        self.urlScheme = urlScheme
        self.serverClientId = serverCliendId
    }
    
    public func userWithId(id: String) -> GoogleUserInstance? {
        for user in authenticatedUsers{
            if user.id == id {
                return user
            }
        }
        return nil
    }
    
    public var redirectURL: String {
        return "\(urlScheme):/oauthredirect"
    }
    
    public func signOutUser(id: String) {
        var index = 0
        for user in authenticatedUsers {
            if user.id == id {
                signinUsersRefreshToken[id] = nil
                authenticatedUsers.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    public func signOutAllUsers() {
        signinUsersRefreshToken.removeAll()
        authenticatedUsers.removeAll()
    }
    
    public func signin(controller: UIViewController, completion: ((_ success: Bool, _ user: GoogleUserInstance?, _ error: String?) -> ())?) {
        
        var audienceParam = [String: String]()
        if let serverClient = serverClientId {
            audienceParam["audience"] = serverClient
        }
        let request = OIDAuthorizationRequest(configuration: getConfiguration(), clientId: cliendId, scopes: scope, redirectURL: URL(string: redirectURL)!, responseType: OIDResponseTypeCode, additionalParameters: audienceParam)
        
        oauthSession = OIDAuthState.authState(byPresenting: request, presenting: controller) { (state, error) in
            if state != nil && state!.isAuthorized {
                let idToken = state?.value(forKey: "idToken")! as! String
                let refreshToken = state?.refreshToken!
                let serverToken = state?.lastTokenResponse?.additionalParameters?["server_code"] as? String
                let accessToken = state?.value(forKey: "accessToken")! as! String
                ExternalRequest.sendExternalRequest(url: "https://www.googleapis.com/oauth2/v2/userinfo", method: .get, param: ["access_token": accessToken as AnyObject, "alt": "json" as AnyObject], completion: { (json) in
                    if json["error"] == JSON.null {
                        self.signinUsersRefreshToken[json["id"].stringValue] = refreshToken!
                        let instance = GoogleUserInstance(email: json["email"].stringValue, name: json["name"].stringValue, familyName: json["family_name"].stringValue, firstName: json["given_name"].stringValue, locale: json["locale"].stringValue, id: json["id"].stringValue, profile: json["picture"].stringValue, refreshToken: refreshToken!, idToken: idToken, accessToken: accessToken, serverToken: serverToken)
                        if self.userWithId(id: instance.id) == nil {
                            self.authenticatedUsers.append(instance)
                        }
                        completion?(true, instance, nil)
                    } else {
                        completion?(false, nil, json["error"].stringValue)
                    }
                })
            } else {
                completion?(false, nil, String(describing: error))
            }
        }
    }
    
    public func signinAllUsersSilently(completion: @escaping ()->() = {}) {
        let group = DispatchGroup()
        for email in signinUsersRefreshToken.keys {
            group.enter()
            backgroundSigninUserSilently(refresh_token: signinUsersRefreshToken[email]!, email: email, completion: { (_, _, _) in
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.main, execute: {
            completion()
        })
    }
    
    public func backgroundSigninUserSilently(refresh_token: String, email: String? = nil, completion: ((_ success: Bool, _ user: GoogleUserInstance?, _ error: OauthError?) -> ())?) {
        let refreshRequest = OIDTokenRequest(configuration: getConfiguration(), grantType: OIDGrantTypeRefreshToken, authorizationCode: nil, redirectURL: URL(string: OauthManager.sharedInstance.redirectURL)!, clientID: OauthManager.sharedInstance.cliendId, clientSecret: nil, scopes: OauthManager.sharedInstance.scope, refreshToken: refresh_token, codeVerifier: nil, additionalParameters: nil)
        ExternalRequest.sendExternalURLRequest(urlRequest: refreshRequest.urlRequest(), completion: { (result) in
            if result["error"] == JSON.null {
                let id_token = result["id_token"].stringValue
                let access_token = result["access_token"].stringValue
                ExternalRequest.sendExternalRequest(url: "https://www.googleapis.com/oauth2/v2/userinfo", method: .get, param: ["access_token": access_token as AnyObject, "alt": "json" as AnyObject], completion: { (json) in
                    if json["error"] == JSON.null {
                        self.signinUsersRefreshToken[json["id"].stringValue] = refresh_token
                        let instance = GoogleUserInstance(email: json["email"].stringValue, name: json["name"].stringValue, familyName: json["family_name"].stringValue, firstName: json["given_name"].stringValue, locale: json["locale"].stringValue, id: json["id"].stringValue, profile: json["picture"].stringValue, refreshToken: refresh_token, idToken: id_token, accessToken: access_token, serverToken: nil)
                        if self.userWithId(id: instance.id) == nil {
                            self.authenticatedUsers.append(instance)
                        }
                        completion?(true, instance, nil)
                    } else {
                        completion?(false, nil, OauthError.UnKnowError(json))
                    }
                })
            } else {
                if result["code"] == 401 {
                    completion?(false, nil, OauthError.RefreshTokenInvalid)
                } else {
                    completion?(false, nil, OauthError.UnKnowError(result))
                }
            }
        })
    }
    
    func getConfiguration() -> OIDServiceConfiguration {
        let authorizationEndpoint = URL(string: "https://accounts.google.com/o/oauth2/v2/auth")
        let tokenEndpoint = URL(string: "https://www.googleapis.com/oauth2/v4/token")
        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint!, tokenEndpoint: tokenEndpoint!)
        return configuration
    }
    
}

public enum OauthError {
    
    case RefreshTokenInvalid
    case UnKnowError(JSON)
    
}
