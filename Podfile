# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'cryptotracker' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for cryptotracker
  pod 'FontAwesome.swift', :git => 'https://github.com/thii/FontAwesome.swift', :branch => 'swift-4.0'
  pod 'Realm'
  pod 'RealmSwift'
  pod 'Anchorage'
  pod 'SDWebImage'
  pod 'PromiseKit'
  pod 'RxRealm'
  pod 'lottie-ios'
  target 'cryptotrackerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'cryptotrackerUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          plist_buddy = "/usr/libexec/PlistBuddy"
          plist = "Pods/Target Support Files/#{target}/Info.plist"
          `#{plist_buddy} -c "Add UIRequiredDeviceCapabilities array" "#{plist}"`
          `#{plist_buddy} -c "Add UIRequiredDeviceCapabilities:0 string arm64" "#{plist}"`
      end
  end
end
