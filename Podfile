# Uncomment this line to define a global platform for your project

platform :ios, '8.0'

use_frameworks!

target 'CKNotificationKit' do
  pod 'CocoaLumberjack/Swift'
end

target 'CKNotificationKitTests' do
    pod 'Quick'
    pod 'Nimble'
end

target 'Sample' do
  pod 'CocoaLumberjack/Swift'
  pod 'SVProgressHUD'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0.1'
    end
  end
end
