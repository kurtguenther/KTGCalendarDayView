#
# Be sure to run `pod lib lint KTGCalendarDayView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "KTGCalendarDayView"
  s.version          = "0.1.0"
  s.summary          = "A short description of KTGCalendarDayView."
  s.description      = <<-DESC
                       An optional longer description of KTGCalendarDayView

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/kurtguenther/KTGCalendarDayView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Kurt Guenther" => "kurtguenther@gmail.com" }
  s.source           = { :git => "https://github.com/kurtguenther/KTGCalendarDayView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/heykurtg'



  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry', '~> 0.5.3'
end
