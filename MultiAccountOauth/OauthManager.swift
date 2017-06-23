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

    dynamic var signinUsers = [String: [String: String]]()
    
    public func configure(cliendId: String, scope: [String], urlScheme: String, serverCliendId: String?) {
        self.cliendId = cliendId
        self.scope = scope
        self.urlScheme = urlScheme
        self.serverClientId = serverCliendId
    }
    
    public func userWithEmail(email: String) -> GoogleUserInstance? {
        for user in authenticatedUsers{
            if user.email == email {
                return user
            }
        }
        return nil
    }
    
    public var redirectURL: String {
        return "\(urlScheme):/oauthredirect"
    }
    
    public func signin(controller: UIViewController, completion: ((_ success: Bool, _ user: GoogleUserInstance?, _ error: String?) -> ())?) {
        
        var audienceParam = [String: String]()
        if let serverClient = serverClientId {
            audienceParam["audience"] = serverClient
        }
        let request = OIDAuthorizationRequest(configuration: getConfiguration(), clientId: cliendId, scopes: scope, redirectURL: URL(string: redirectURL)!, responseType: OIDResponseTypeCode, additionalParameters: audienceParam)
        
        oauthSession = OIDAuthState.authState(byPresenting: request, presenting: controller) { (state, error) in
            if state != nil && state!.isAuthorized {
                let idToken = state?.value(forKey: "idToken")! as? String
                let refreshToken = state?.refreshToken!
                let serverToken = state?.lastTokenResponse?.additionalParameters?["server_code"] as? String
                let accessToken = state?.value(forKey: "accessToken")! as? String
                ExternalRequest.sendExternalRequest(url: "https://www.googleapis.com/oauth2/v2/userinfo", method: .get, param: ["access_token": accessToken as AnyObject, "alt": "json" as AnyObject], completion: { (json) in
                    if json["error"] == JSON.null {
                        print(json)
                        let name = json["name"].stringValue
                        let id = json["id"].stringValue
                        let profile = json["picture"].stringValue
                        let email = json["email"].stringValue
                        self.signinUsers[id] = ["refreshToken": refreshToken!]
                        let instance = GoogleUserInstance(email: email, name: name, id: id, profile: profile, refresh_token: refreshToken!, id_token: idToken!, access_token: accessToken, server_token: serverToken)
                        if self.userWithEmail(email: email) == nil {
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
    
    public func backgroundSigninUserSilently(refresh_token: String, completion: @escaping ((_ success: Bool, _ result: JSON) -> ())) {
        let refreshRequest = OIDTokenRequest(configuration: getConfiguration(), grantType: OIDGrantTypeRefreshToken, authorizationCode: nil, redirectURL: URL(string: OauthManager.sharedInstance.redirectURL)!, clientID: OauthManager.sharedInstance.cliendId, clientSecret: nil, scopes: OauthManager.sharedInstance.scope, refreshToken: refresh_token, codeVerifier: nil, additionalParameters: nil)
        ExternalRequest.sendExternalURLRequest(urlRequest: refreshRequest.urlRequest(), completion: { (result) in
            completion(result["error"] == JSON.null, result)
        })
    }
    
    func getConfiguration() -> OIDServiceConfiguration {
        let authorizationEndpoint = URL(string: "https://accounts.google.com/o/oauth2/v2/auth")
        let tokenEndpoint = URL(string: "https://www.googleapis.com/oauth2/v4/token")
        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint!, tokenEndpoint: tokenEndpoint!)
        return configuration
    }
    
}
