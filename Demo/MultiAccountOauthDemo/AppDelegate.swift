//
//  AppDelegate.swift
//  MultiAccountOauthDemo
//
//  Created by Li Kedan on 6/23/17.
//  Copyright © 2017 Thywis inc. All rights reserved.
//

import UIKit
import MultiAccountOAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        OauthManager.sharedInstance.configure(cliendId: "269767058620-boug6i0q16vsh7a90cf7341skc1j91sj.apps.googleusercontent.com", scope: ["email"], urlScheme: "com.googleusercontent.apps.269767058620-boug6i0q16vsh7a90cf7341skc1j91sj", serverCliendId: nil)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let oauthSession = OauthManager.sharedInstance.oauthSession {
            if oauthSession.resumeAuthorizationFlow(with: url) {
                OauthManager.sharedInstance.oauthSession = nil
                return true
            }
        }
        return false
    }

}

