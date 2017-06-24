# MultiAccountOAuth

MultiAccountOAuth allows you to login to multiple Google OAuth accounts simultaneouly. 

<img src="img/screenshot.png" width="375" height="667"/>

While developing [PickedMail - The personal AI Inbox](https://itunes.apple.com/us/app/pickedmail/id1244830423?mt=8), we need to support user login to multiple Google accounts simultaneously. However, Google iOS SDK only allows user to sign in to one account at a time. As a result, we developed a framework to allow us to sign in and maintain connection status to multiple Google accounts. This framework is open sourced to help others who struggling through the same problem.

## Requirements
* Swift 3.0+
* Xcode 8.0+
* iOS 9.0+, OSX 10.10+


### Scopes
https://developers.google.com/identity/protocols/googlescopes

