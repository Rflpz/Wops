platform :ios, '8.0'
pod 'NYAlertViewController'
pod 'KVNProgress'
pod "AFNetworking", "~> 2.0"
pod "STZPullToRefresh"
pod 'MKInputBoxView'
# disable bitcode in every sub-target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
     end
  end
end
