# MultiAccountOAuth

MultiAccountOAuth allows you to login to multiple Google OAuth accounts simultaneouly. 

<img src="img/screenshot.png" width="375" height="667"/>

While developing [PickedMail - The personal AI Inbox](https://itunes.apple.com/us/app/pickedmail/id1244830423?mt=8), we need to support user login to multiple Google accounts simultaneously. However, Google iOS SDK only allows user to sign in to one account at a time. As a result, we developed a framework to allow us to sign in and maintain connection status to multiple Google accounts. This framework is open sourced to help others who struggling through the same problem.

## Install
```ruby
pod 'MultiAccountOAuth'
```

## Requirements
* Swift 3.0+
* Xcode 8.0+
* iOS 9.0+, OSX 10.10+

### Step by Step Guide

## AppDelegate.swift
Add you google client id and url Scheme to the framework. You can also provide a server client if you'd like to enable backend access

```swift
import UIKit
import MultiAccountOauth

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

```



### Scopes
https://developers.google.com/identity/protocols/googlescopes

