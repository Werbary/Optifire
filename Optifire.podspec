#
# Be sure to run `pod lib lint Optifire.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Optifire'
  s.version          = '0.0.1'
  s.summary          = 'Google Firebase Database without pain.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/werbary/Optifire'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'itruf' => 'itruf@werbary.ru' }
  s.source           = { :git => 'https://github.com/werbary/Optifire.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Optifire/**/*'

  s.xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/FirebaseCore/Frameworks/frameworks" "$(PODS_ROOT)/FirebaseAnalytics/Frameworks/frameworks" "$(PODS_ROOT)/FirebaseDatabase/Frameworks" "$(PODS_ROOT)/GoogleInterchangeUtilities/Frameworks/frameworks" "$(PODS_ROOT)/GoogleSymbolUtilities/Frameworks/frameworks"',
      'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/Firebase/Core/Sources'
  }

 # s.dependency = 'FirebaseDatabase'
  s.frameworks = ['FirebaseDatabase']
end
