#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint screen_security.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'screen_security'
  s.version          = '1.1.0'
  s.summary          = 'Prevent screen capturing and recording on iOS and Android.'
  s.description      = <<-DESC
A zero-dependency Flutter plugin that prevents screen capturing and screen recording.
On Android it uses FLAG_SECURE. On iOS it injects the Flutter view into a secure
UITextField layer, avoiding the common camera-black-screen conflict.
                       DESC
  s.homepage         = 'https://github.com/Kidpech-code/screen_security'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'kidpech' => 'kidpechpianpithak@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  s.resource_bundles = {'screen_security_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
