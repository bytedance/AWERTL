Pod::Spec.new do |s|
  s.name             = 'AWERTL'
  s.version          = '1.0.0'
  s.summary          = 'AWERTL is an iOS library to adapt RTL(right-to-left) UI automatically'

  s.description      = <<-DESC
AWERTL can help your project to become user friendly in RTL regions, it can work with your existing projects seemlessly using method swizzle.
                       DESC

  s.homepage         = 'https://github.com/bytedance/AWERTL'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bytedance' => 'bytedance@bytedance.com' }
  s.source           = { :git => 'https://github.com/bytedance/AWERTL.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'AWERTL/Classes/**/*'

  s.dependency 'RSSwizzle'
end
