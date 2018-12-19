Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '10.0'
s.swift_version = '4.2'
s.name = "ChatAssistant"
s.summary = "Chat assistant"
s.author = { "Rafał Urbaniak" => "rafal.urbaniak@rndity.com" }
s.homepage = "https://rndity.com"
s.license = { :type => "MIT" }

s.version = "1.0.3"
s.requires_arc = true
s.source = { :path => '.' }
s.source_files = "true", "ChatAssistant/**/*.{h,m,swift}"

s.framework = "UIKit"

s.resources = [
'ChatAssistant/**/*.{xib,xcassets,strings}'
]

s.dependency 'TinyConstraints', '~> 3.3.0'
s.dependency 'EasyAnimation', '~> 2.2.1'
s.dependency 'ViewAnimator'

end
