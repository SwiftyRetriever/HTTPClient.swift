#
#  Be sure to run `pod spec lint HTTPClient.swift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HTTPClient.swift"
  s.module_name  = "HTTPClient"
  s.version      = "0.0.1"
  s.summary      = "A Network Layer base on Alamofire"

  s.description  = <<-DESC
                    A Network Layer base on Alamofire.
                    1. Support DataRequest
                    2. Suppert DownloadRequest
                    3. Suppert UploadRequest
                   DESC

  s.homepage     = "hhttps://github.com/zevwings/HTTPClient.swift"
  s.license      = "MIT"
  s.author       = { "zevwings" => "zev.wings@gmail.com" }
  s.source       = { "https://github.com/zevwings/HTTPClient.swift.git", :tag => s.version }

  s.default_subspec = "Core"
  s.swift_version = '4.2'
  s.cocoapods_version = '>= 1.4.0'  

  s.subspec "Core" do |core|
    core.source_files  = "HTTPClient/**/*.{h,m,swift}"
    core.dependency "Alamofire"
    core.dependency "Result"
    core.framework  = "Foundation"
  end

  s.subspec "RxSwift" do |rx|
    rx.source_files = "RxHTTPClient/**/*.{h,m,swift}"
    rx.dependency "HTTPClient.swift/Core"
    rx.dependency "RxSwift"
  end

end
