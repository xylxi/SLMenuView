Pod::Spec.new do |s|
    s.name         = "SLMenuView"
    s.version      = "1.0.0"
    s.summary      = "一个类似QQ弹出多个选项的空间以及一个复杂View弹出的类"
    s.description  = <<-DESC
                        通过指定item的个数以及配置属性，创建弹出视图，并且可以根据枚举值，
                        选择弹出样式。
                    DESC
    s.homepage     = "https://github.com/xylxi/SLMenuView"

    s.license      = 'MIT'
    s.author       = { "XYLXI" => "377793267@qq.com" }
    s.source       = { :git => "https://github.com/xylxi/SLMenuView.git", :tag => s.version }

    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.source_files = 'SLMenuView/*.swift'
    s.frameworks = 'Foundation', 'UIKit'
    #s.private_header_files = 'Classes/ios/private/*.h'
end