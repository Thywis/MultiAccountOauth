#
# Be sure to run `pod lib lint MultiAccountOauth.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MultiAccountOauth"
  s.version          = "1.0"
  s.summary          = "Login to multiple Google accounts or any other OAuth service simultaneouly."

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.description      = "While developing Pickedmail - The personal AI Inbox, we need to support user login to multiple Google accounts simultaneously. However, Google iOS SDK only allow user to sign in to one account at a time. As a result, we developed a framework to allow user to sign and maintain connection status to multiple Google account. We open sourced this framework to help others who are struggling through the same problem."

  s.homepage         = "https://github.com/Thywis/MultiAccountOauth"
s.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
LICENSE
}
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
