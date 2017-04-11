source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

def shared_pods
    pod 'AFNetworking'
end

target 'pinned' do
shared_pods
pod 'MJRefresh'
end

target 'NetworkingKit' do
shared_pods
end

target 'pinnedShareExtension' do
    shared_pods
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        if target.name == "AFNetworking"
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'AF_APP_EXTENSIONS=1']
            end
        end
    end
end
