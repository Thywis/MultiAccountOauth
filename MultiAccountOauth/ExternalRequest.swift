//
//  APIRequest.swift
//  Taste
//
//  Created by Li Kedan on 11/22/16.
//  Copyright © 2016 Li Kedan. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ExternalRequest {

    class func sendExternalRequest(url: String, method: HTTPMethod, param: [String: AnyObject]?, completion: @escaping (JSON)->()) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 3
        manager.request(url, method: method, parameters: param, encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                completion(JSON(["success": false, "error": String(describing: error)]))
            }
        }
    }

    class func sendExternalURLRequest(urlRequest: URLRequest, completion: @escaping (JSON)->()) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 3
        manager.request(urlRequest).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                completion(JSON(["success": false, "error": String(describing: error), "code": response.response?.statusCode as Any]))
            }
        }
    }
    
}
