Pod::Spec.new do |s|

  s.name             = 'WQCharts'
  s.version          = '1.0.0'
  s.summary          = 'WQCharts is a powerful & easy to use chart library for iOS'
  s.homepage         = 'https://github.com/CoderWQYao/WQCharts-iOS'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "WQ.Yao" => "wqcoder@gmail.com" }
  s.source           = { :git => 'https://github.com/CoderWQYao/WQCharts-iOS.git', :tag => s.version.to_s }
  s.ios.deployment_target = "8.0"
  s.swift_version = '5.0'
  s.source_files = 'WQCharts/Classes/**/*.swift'

end
