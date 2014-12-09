Pod::Spec.new do |s|
  s.name         = "COOLKit"
  s.version      = "0.0.1"
  s.summary      = "COOL application components."

  s.description  = <<-DESC
COOL application components.
                   DESC

  s.homepage     = "https://github.com/ilyapuchka/COOLKit"
  s.license      = "MIT"
  s.author       = { "Ilya Puchka" => "ilya@puchka.me" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "git@github.com:ilyapuchka/COOLKit.git", :tag => "0.0.1" }
  s.requires_arc = true

  s.default_subspecs = 'Compositions', 'NetworkStack', 'DataSources', 'Decorators'

  s.subspec 'Compositions' do |cmp|
    cmp.source_files = "COOLKit/COOLCompositions/**/*.{h,m}"
  end

  s.subspec 'NetworkStack' do |ns|
    ns.source_files = "COOLKit/COOLNetworkStack/**/*.{h,m}"
    ns.dependency 'AFNetworking', '~>2.5.x'
    ns.dependency 'AFNetworkActivityLogger', '~>2.0.x'
    ns.dependency 'EasyMapping', '~>0.8.x'
  end

  s.subspec 'DataSources' do |ds|
    ds.source_files = "COOLKit/COOLDataSources/**/*.{h,m}"
    ds.dependency 'COOLKit/Compositions'
    ds.dependency 'COOLKit/NetworkStack'
  end

  s.subspec 'Decorators' do |dec|
    dec.source_files = "COOLKit/COOLDecorators/**/*.{h,m}"
    dec.public_header_files = 'COOLKit/COOLDecorators/Public/**/*.h'
    dec.dependency 'COOLKit/Compositions'
  end
  
end
