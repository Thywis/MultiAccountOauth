#
# Be sure to run `pod lib lint MultiAccountOAuth.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MultiAccountOAuth"
  s.version          = "1.0"
  s.summary          = "Login to multiple Google OAuth accounts simultaneouly."

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.description      = "While developing [PickedMail - The personal AI Inbox](https://itunes.apple.com/us/app/pickedmail/id1244830423?mt=8), we need to support user login to multiple Google accounts simultaneously. However, Google iOS SDK only allows user to sign in to one account at a time. As a result, we developed a framework to allow us to sign in and maintain connection status to multiple Google accounts. This framework is open sourced to help others who struggling through the same problem."

  s.homepage         = "https://github.com/Thywis/MultiAccountOauth"
  s.license          = 'MIT'
  s.author           = { "likedan" => "likedan5@icloud.com" }
  s.source           = { :git => "https://github.com/Thywis/MultiAccountOauth.git", :tag => "1.0.0" }
   s.social_media_url = 'https://itunes.apple.com/us/app/pickedmail/id1244830423?mt=8'

  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.dependency 'AppAuth', '~> 0.9.1'
  s.dependency 'SwiftyJSON', '~> 3.1.4'
  s.dependency 'Alamofire', '~> 4.5.0'
  s.source_files = 'MultiAccountOauth/*.swift'

end
