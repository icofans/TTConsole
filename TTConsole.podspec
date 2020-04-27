Pod::Spec.new do |s|
  s.name             = 'TTConsole'
  s.version          = '0.1.8'
  s.summary          = 'A short description of TTConsole.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/icofans/TTConsole'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'icofans' => '565057208@qq.com' }
  s.source           = { :git => 'https://github.com/icofans/TTConsole.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'TTConsole/*.{h,m}'
  
  s.subspec 'Console' do |ss|
      ss.source_files = 'TTConsole/Console/*.{h,m}'
      ss.frameworks = 'UIKit'
      ss.dependency 'TTConsole/Log'
      ss.dependency 'TTConsole/Env'
      ss.dependency 'TTConsole/Http'
      ss.dependency 'TTConsole/Crash'
      ss.dependency 'TTConsole/Sandbox'
  end
  s.subspec 'Log' do |ss|
      ss.source_files = 'TTConsole/Log/*.{h,m}'
      ss.frameworks = 'UIKit'
  end
  s.subspec 'Env' do |ss|
      ss.source_files = 'TTConsole/Env/*.{h,m}'
      ss.frameworks = 'UIKit'
  end
  s.subspec 'Http' do |ss|
      ss.source_files = 'TTConsole/Http/*.{h,m}'
      ss.frameworks = 'UIKit'
  end
  s.subspec 'Crash' do |ss|
      ss.source_files = 'TTConsole/Crash/*.{h,m}'
      ss.frameworks = 'UIKit'
  end
  s.subspec 'Sandbox' do |ss|
      ss.source_files = 'TTConsole/Sandbox/*.{h,m}'
      ss.frameworks = 'QuickLook','UIKit'
  end
  s.resource_bundles = {
      'Console' => ['TTConsole/Assets/Resource/*.png']
  }
  s.dependency 'fishhook'
  
end
