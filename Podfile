# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BabyApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BabyApp
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'NVActivityIndicatorView/AppExtension'
  pod 'JGProgressHUD'
  pod 'SDWebImage'
  pod 'Google-Mobile-Ads-SDK'
  pod 'lottie-ios'
  pod 'Parchment'
  pod 'TextFieldEffects'
  pod 'RAMAnimatedTabBarController'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end

  target 'BabyAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BabyAppUITests' do
    # Pods for testing
  end

end
