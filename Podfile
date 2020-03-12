

#source 'git@git.musjoy.com:PodSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'
source 'https://gitlab.com/novapps/ios-app/framework/private-cocoapods-spec-repo.git'
source 'https://github.com/aliyun/aliyun-specs.git'


#, :path => '~/Pods/MJThemeManager'
platform :ios, '11.0'

target 'amplifier' do
    
    use_frameworks!
    
    
#    pod 'ModuleCapability'          # 常用模块的宏定义
#    # 控制器相关
#    pod 'MJControllerManager'       # 控制器管理
#    pod 'MJTabBarManager'           # TabBar控制器基类
#    pod 'MJWebViewController'       # 网页控制器
#    # 通用视图
#    pod 'MJAlertManager'            # 通用弹框
#    pod 'MJToast'                   # 自动消失的提示框
#    pod 'MJLoadingView'             # Loading视图
#    # 网络请求
#    pod 'MJInterfaceManager'        # 设备注册请求
#    pod 'WebInterface'              # 与自己服务器交互的网络请求
#    pod 'MJWebService'              # 通用网络请求
#
#    # 常用模块
#    pod 'LaunchManager'             # 启动时, 方法延时执行, 加快启动速度
    pod 'MJUtils'                   # 常用类类目（工具类）
#    pod 'MJCacheManager'            # 缓存管理
#    pod 'MJDevice'                  # 设备信息
#    pod 'MJKeychain'                # keychain存储
    pod 'SDWebImage'
    pod 'MBProgressHUD'
    pod 'AFNetworking'
    
    pod 'Toast'
    
    pod 'CWLateralSlide'
    
    
    pod 'NOVAdKit/Core'
    pod 'NOVAdKit/GDT'
    pod 'NOVAdKit/ByteDance'
    pod 'NOVAppReview'

    pod 'UMCAnalytics'
    pod 'UMCCommonLog', :configurations => ['Debug']
    
end

#post_install do |installer_representation|
#    
#    # 读取项目名称
#    firstAggregateTarget = installer_representation.aggregate_targets.first
#    
#    # 读取用户中多出来的宏定义
#    the_user_config =  firstAggregateTarget.xcconfigs.first.last
#    a_gcc_config = the_user_config.attributes['GCC_PREPROCESSOR_DEFINITIONS']
#    the_gcc_config = a_gcc_config.split("COCOAPODS=1 ")[1]
#    
#    the_build_setting = {
#        'GCC_PREPROCESSOR_DEFINITIONS' => the_gcc_config,
#        'HEADER_SEARCH_PATHS' => "\"$(PROJECT_DIR)/../Public\""
#    }
#    
#    # 将这些宏定义应用于其它target
#    installer_representation.pod_targets.sort_by(&:name).each do |target|
#
#        # 跳过没有不需要编译的target
#        next if target.target_definitions.flat_map(&:dependencies).empty?
#        next if !target.should_build?
#        
#        # 重新保存每个pod target
#        path = target.xcconfig_path
#        xcconfig_gen = Generator::XCConfig::PodXCConfig.new(target)
#        xcconfig = xcconfig_gen.generate
#        xcconfig.merge!(the_build_setting)
#        xcconfig.save_as(path)
#        
#    end
#    
#end
