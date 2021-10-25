#
# Be sure to run `pod lib lint JKOAuthenticate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKOAuthenticate'
  s.version          = '1.0.0'
  s.summary          = 'A SDK which help developer requesting authentication from JKOS App'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  -
                       DESC

  s.homepage         = 'https://github.com/claudleei/ios_login_sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JKOS' => 'mobilegroup@jkos.com' }
  s.source           = { :git => 'https://github.com/claudleei/ios_login_sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.platform    = :ios, '11.0'
  s.requires_arc = true
  s.swift_version = '5.0'

  s.vendored_frameworks = 'JKOAuthenticate/*.{xcframework}'
  s.source_files = 'JKOAuthenticate/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JKOAuthenticate' => ['JKOAuthenticate/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
