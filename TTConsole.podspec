Pod::Spec.new do |s|
  s.name             = 'TTConsole'
  s.version          = '0.1.1'
  s.summary          = 'A short description of TTConsole.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/icofans/TTConsole'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'icofans' => '565057208@qq.com' }
  s.source           = { :git => 'https://github.com/icofans/TTConsole.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'TTConsole/Classes/**/*'
end
