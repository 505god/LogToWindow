#
#  Be sure to run `pod spec lint LogToWindow.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LogToWindow"
  s.version      = "1.0.4"
  s.summary      = "Debug模式下宏定义log打印输出到window层"
  s.homepage     = "https://github.com/505god/LogToWindow"

  s.license      = "MIT"
  s.author             = { "qcx" => "18915410342@126.com" }
  s.platform     = :ios
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/505god/LogToWindow.git", :tag => "1.0.4" }
  s.source_files  = 'LogToWindow/Classes/*.{h,m}'
  s.requires_arc = true

end
