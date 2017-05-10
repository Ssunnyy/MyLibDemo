Pod::Spec.new do |s|
  s.name             = "SloppySwiper"
  s.version          = "0.5"
  s.summary          = "UINavigationController delegate that allows swipe back gesture to be started from anywhere on the screen (not just from the edge)."
  s.homepage         = "https://github.com/fastred/SloppySwiper"
  s.license          = 'MIT'
  s.author           = { "Arkadiusz Holko" => "fastred@fastred.org" }
  s.social_media_url = "https://twitter.com/arekholko"
  s.source           = { :git => "https://github.com/fastred/SloppySwiper.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'Classes'
  s.public_header_files = 'Classes/*.h'
end
