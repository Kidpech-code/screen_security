#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint screen_security.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'screen_security'
  s.version          = '1.1.1'
  s.summary          = 'Best-effort screenshot and screen-recording protection for Flutter apps.'
  s.description      = <<-DESC
A Flutter plugin with no third-party native runtime dependencies, providing best-effort
screenshot and screen-recording protection. On Android it uses FLAG_SECURE. On iOS it
hosts the Flutter view inside a secure UITextField layer, reducing exposure through
normal OS capture paths without replacing the application window. Known platform
limitations are documented in the package README.
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
