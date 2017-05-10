NSAppTransportSecurity
下添加NSAllowsArbitraryLoads类型 YES
$(SRCROOT)
OS_ACTIVITY_MODE : disable

//  打包地址  /Users/zhaoyunzhou/Library/Developer/Xcode/Archives/
更换包的路径 ->  应用程序-Xcode–显示包内容-contents–Developer–Platforms–iPhoneOS.platform–DeviceSupport里

TabbarController
//github： https://github.com/renzifeng/ZFTabBar/issues/2
//添加监听
[[CentralManager sharedManager] addEventListener:self];
//开始扫描服务
CBUUID *servUUID = [CBUUID UUIDWithString:HEART_UUID];
NSArray * arr = @[servUUID];
//开始监听
[[CentralManager sharedManager]startdiscoverSerVices:[CentralManager sharedManager].deviceTied WithUUID:arr];
#pragma mark - 从蓝牙 接收运动数据
- (void)didUpdateDeviceValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([[characteristic.UUID UUIDString] isEqualToString:WARNING_DATA_READ_UUID]) {
        unsigned char* txValue = (unsigned char*)[characteristic.value bytes];
        print_hex_ascii_line(txValue, 20, 0);
        char retjson[512] = {0};
        parseDateSync(txValue, retjson);
        DDLog(@"  用药：step json = %s", retjson);

        //解析运动的数值
        //"{\"key\":%d, \"value\":{\"datasum\":%d,\"step\":%d,\"range\":%d, \"Kals\":%d}}
        
        NSString *strData = [NSString stringWithUTF8String:retjson];
        
        NSDictionary *sportDic = [NSString parseJSONStringToNSDictionary:strData];
        
        int rootDic = [[sportDic objectForKey:@"key"] intValue];
        
    }
}
/**
 //获取当前音量，不改变使用者音量
 -(float) getVolumeLevel
 {
 MPVolumeView *slide =[[MPVolumeView alloc]init];
 UISlider *volumeViewSlider;
 for(UIView*view in[slide subviews])
 {
 if([[[view class] description] isEqualToString:@"MPVolumeSlider"])
 {
 volumeViewSlider =(UISlider*) view;
 }
 }
 float val =[volumeViewSlider value];;
 return val;
 }
 MPVolumeView *volumeView = [[MPVolumeView alloc] init];
 UISlider* volumeViewSlider = nil;
 for (UIView *view in [_instance.volumeView subviews]){
 if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
 volumeViewSlider = (UISlider*)view;
 break;
 }
 }
 
 // retrieve system volume
 float systemVolume = volumeViewSlider.value;
 
 // change system volume, the value is between 0.0f and 1.0f
 [volumeViewSlider setValue:1.0f animated:NO];
 
 // send UI control event to make the change effect right now.
 [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
 
 http://blog.csdn.net/qq_30513483/article/details/51198464  自定义相机
 **/

//  iOS 键盘框架IQKeyboardManager使用
//  框架地址：https://github.com/hackiftekhar/IQKeyboardManager
在AppDelegate.m文件中

#import <IQKeyboardManager.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    IQKeyboardManager *manager = [IQKeyboardManagersharedManager];
    //    控制整个功能是否启用。
    manager.enable = YES;
    manager.overrideKeyboardAppearance = YES;
    //控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    //    //控制键盘上的工具条文字颜色是否用户自定义。  注意这个颜色是指textfile的tintcolor
    //    manager.shouldToolbarUsesTextFieldTintColor = YES;
    //    //中间位置是否显示占位文字(默认是YES)
    //    manager.shouldShowTextFieldPlaceholder = YES;
    //    //设置占位文字的字体大小
    manager.placeholderFont = [UIFontboldSystemFontOfSize:18];
    //控制是否显示键盘上的工具条。
    manager.enableAutoToolbar = YES;
    //某个类中禁止使用工具条
    //    [[IQKeyboardManager sharedManager]disableToolbarInViewControllerClass:[UIViewController class]];
    returnYES;
}

//定时器
self.timeout=TIMETEST; //倒计时时间
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
dispatch_source_set_event_handler(_timer, ^{
    
});
dispatch_resume(_timer);

图片名称
iphone(Portrait) Launch Screen的规格：

none Default.png (320 x 480) iPhone 3GS

Default@2x.png (640 x 960)就是iphone4/4s使用的

Default-568h@2x.png  (640x 1136) iphone5/5s

Default-667h@2x.png  (750 x 1334) iphone6

Default-736h@3x.png  (1242 x 2208) iphone6 plus

根据横(Landscape)、竖(Portrait)屏iPad有如下几种(主要区别在于是否为Retina屏)：

Default-Portrait.png (768 x 1024)

Default-Portrait@2x.png (1536 x 2048)

Default-Landscape.png (1024 x 768)

Default-Landscape@2x.png  (2048 x 1536)

如果有导航显示，那么相应的“高度”需要减少40，如768 x 1004

iPhone 6 Plus      Default-Landscape-736h
iPhone 6           Default-667h
iPhone 5           Default-568h
iPhone 4           Default

//改变状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}

添加Dock最近使用
终端输入如下命令
defaults write com.apple.dock persistent-others -array-add '{"tile-data" = {"list-type" = 1;}; "tile-type" = "recents-tile";}'; killall Dock

显示：defaults write com.apple.finder AppleShowAllFiles -bool true
隐藏：defaults write com.apple.finder AppleShowAllFiles -bool false
火狐浏览器打不开时  终端输入： /Applications/Firefox.app/Contents/MacOS/firefox-bin -profilemanager

如果没有’任何来源‘这个选项的话（macOS Sierra 10.12）,打开终端，执行sudo spctl --master-disable即可

#pragma mark - 横屏代码
- (BOOL)shouldAutorotate
{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}
//两日期相减
NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
NSDateComponents * dayComponents = [calendar components:NSCalendarUnitDay fromDate:picker.date toDate:NSDate.date options:0];
[NSString stringWithFormat:@"相减得的天数:%ld",dayComponents.day];

//  毛玻璃效果
UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height)];
toolbar.barStyle = UIBarStyleBlackTranslucent;
[bgImgView addSubview:toolbar];

//vim文件内容格式
platform :ios, "8.0"
use_frameworks!

target "GesturePassword" do
pod 'Masonry', '~> 0.6.4'
end

/Users/zhaoyunzhou/Library/MobileDevice/Provisioning Profiles     //描述文件路径
