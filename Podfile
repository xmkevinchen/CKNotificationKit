# Uncomment this line to define a global platform for your project

platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

def testing_pods
  pod 'Quick', '~> 0.8.0'
  pod 'Nimble', '~> 3.0.0'
end

target 'CKNotificationKit' do
  pod 'CocoaLumberjack/Swift'
end

target 'CKNotificationKitTests', :exclusive => true do
  testing_pods
end
