
  Pod::Spec.new do |s|
    s.name = 'CapacitorGameServices'
    s.version = '0.0.1'
    s.summary = 'A native only plugin for google's play services library and apple's game center library'
    s.license = 'MIT'
    s.homepage = 'https://github.com/openforge/capacitor-game-services'
    s.author = 'OpenForge'
    s.source = { :git => 'https://github.com/openforge/capacitor-game-services', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
  end