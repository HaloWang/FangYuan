Pod::Spec.new do |s|
  s.name         = "FangYuan"
  s.version      = "0.0.3"
  s.summary      = "Light weight, high-performance manual layout framework."
  s.homepage     = "https://github.com/HaloWang/Halo"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "王策" => "634692517@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/HaloWang/FangYuan.git", :tag => "0.0.3" }
  s.source_files = "FangYuan/*.{swift}"
  s.frameworks   = "UIKit"
  s.requires_arc = true
end
