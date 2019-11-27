#
# Be sure to run `pod lib lint WSAP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WSAP'
  s.version          = '0.5.0'
  s.summary          = 'A short description of WSAP.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/CuriosityHealth/WSAP-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jdkizer9' => 'james@curiosityhealth.com' }
  s.source           = { :git => 'https://github.com/CuriosityHealth/WSAP-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'WSAP/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WSAP' => ['WSAP/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Gloss', '~> 2.0'
  s.dependency 'LS2SDK', '~> 0.10'
  s.dependency 'ResearchKit', '~> 1.5'
  s.dependency 'ResearchSuiteExtensions', '~> 0.22'
  s.dependency 'ResearchSuiteTaskBuilder', '~> 0.13'
  s.dependency 'ResearchSuiteResultsProcessor', '~> 0.9'
  s.dependency 'ResearchSuiteApplicationFramework', '~> 0.23'
  s.dependency 'SnapKit', '~> 4.0'
  s.resources = 'WSAP/Assets/Assets.xcassets'
end
