//
//  CentralManager.m
//  HealthGuard
//
//  Created by LaoTao on 15/11/2.
//  Copyright © 2015年 LaoTao. All rights reserved.
//

#import "CentralManager.h"

#import "ecg_algo.h"


BOOL IsBlueToothOpen = NO;



@interface CentralManager ()<CBCentralManagerDelegate, CBPeripheralDelegate,CentralManagerDelegate>
{

}

@end

@implementation CentralManager
{
    NSMutableArray *_listener;  //观察者
           //设备数组
}

#pragma mark - 单例
+ (CentralManager *)sharedManager {
    static CentralManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit {
    _listener = [NSMutableArray array];
    _deviceArray = [NSMutableArray array];
    
    _deviceBleState = BleManagerStateDisconnect;
    
    //建立中心角色
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    self.callCentter = [[CTCallCenter alloc]init];
    
}

//添加监听
- (void)addEventListener:(id <CentralManagerDelegate>)listener {
    [_listener addObject:listener];
}

//删除监听
- (void)removeEventListener:(id <CentralManagerDelegate>)listener {
    [_listener removeObject:listener];
}

/**
 *  删除所有监听
 */
- (void)removeAllEventListener {
    [_listener removeAllObjects];
}

/**
 *  取消所有蓝牙连接
 */
- (void)cancelPeripheralConnection {
    if (self.deviceTied) {
        [_manager cancelPeripheralConnection:self.deviceTied];
        self.deviceTied = nil;
    }
    
    _deviceBleState = BleManagerStateDisconnect;
    [self stopManagerScan];
    
    for (id listener in _listener) {
        if ([listener respondsToSelector:@selector(didCancelDevicePeripheralConnection)]) {
            [listener didCancelDevicePeripheralConnection];
        }
    }
}

/**
 *  取消蓝牙搜索
 */
- (void)stopManagerScan {
    if (_manager) {
        [_manager stopScan];
    }
}
+ (BOOL)isBlueOpen
{
    return IsBlueToothOpen;
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *stateStr;
    switch (central.state) {
        case CBCentralManagerStateUnknown :
            IsBlueToothOpen = NO;
            stateStr = @"当前蓝牙状态未知，请重试";
            break;
        case CBCentralManagerStateUnsupported:
            IsBlueToothOpen = NO;
            stateStr = @"当前设备不支持蓝牙设备连接";
            break;
        case CBCentralManagerStateUnauthorized:
            IsBlueToothOpen = NO;
            stateStr = @"请前往设置开启蓝牙授权并重试";
            break;
        case CBCentralManagerStatePoweredOff:
            IsBlueToothOpen = NO;
            stateStr = @"蓝牙关闭，请开启";
            break;
            
        case CBCentralManagerStateResetting:
            IsBlueToothOpen = NO;
            break;
        case CBCentralManagerStatePoweredOn:
        {
            IsBlueToothOpen = YES;
            stateStr = @"正常";
            //扫描外设(discover)
            DDLog(@"扫描外设");
            
//            NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:YES]};
            //开始扫描设备
            [self searchDeviceModule];
            
//            [_manager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        default:
            stateStr = [NSString stringWithFormat:@"蓝牙异常 %d",(int)central.state];
            break;
    }
}
/**
 *  验证蓝牙是否可用
 */
- (BOOL)verifyCentralManagerState {
    if (_manager.state != CBCentralManagerStatePoweredOn) {
        for (id listener in _listener) {
            if ([listener respondsToSelector:@selector(centralManagerStatePoweredOff)]) {
                [listener centralManagerStatePoweredOff];
            }
        }
        
        return NO;
    }
    return YES;
}

//***************************
//****设备
//***************************
//搜索设备
- (void)searchDeviceModule {
//    if (![self verifyCentralManagerState]) {
//        return;
//    }
    DDLog(@"搜索设备");
//     [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES ,CBConnectPeripheralOptionNotifyOnConnectionKey : @NO}];
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
    //
}

//连接蓝牙设备
- (void)connectDevicePeripheralWithPeripheral:(CBPeripheral *)peripheral {
    if (![self verifyCentralManagerState]) {
        return;
    }
    if (peripheral == nil) {
        return;
    }
    self.deviceTied = peripheral;
    [_manager connectPeripheral:peripheral options:@{ CBConnectPeripheralOptionNotifyOnConnectionKey : @YES}];
}

#pragma mark - *******************
/**
 *  这里开始蓝牙的代理方法
 */
#pragma mark - >> 发现蓝牙设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (!peripheral.name) {
        return;
    }
    
    NearbyPeripheralInfo *infoModel = [[NearbyPeripheralInfo alloc] init];
    infoModel.peripheral = peripheral;
    infoModel.advertisementData = advertisementData;
    infoModel.RSSI = RSSI;

    //设备
    DDLog(@"蓝牙管理者 发现设备Device:%@, %.2f", peripheral.name, RSSI.floatValue);
    
    if (_deviceArray.count == 0) {
        [_deviceArray addObject:infoModel];
    }else {
        BOOL isExist = NO;
        for (int i = 0; i < _deviceArray.count; i++) {
            NearbyPeripheralInfo *model = _deviceArray[i];
            
            if ([model.peripheral isEqual:peripheral]) {
                isExist = YES;
                _deviceArray[i] = infoModel;
            }
        }
        if (!isExist) {
            [_deviceArray addObject:infoModel];
        }
    }
    
    
    for (id listener in _listener) {
        if ([listener respondsToSelector:@selector(didDiscoverDevicePeripheral:devices:)]) {
            [listener didDiscoverDevicePeripheral:peripheral devices:_deviceArray];
        }
    }

}

#pragma mark - >> 连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接成功:%@", peripheral.name);
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    myDelegate.devicesTied = peripheral;

    [self stopManagerScan];   //停止扫描设备
    
    self.callCentter.callEventHandler = ^(CTCall*call)
    {
        if (call.callState == CTCallStateDisconnected)
        {
            DDLog(@"Call has been disconnected");
            //            self.viewController.signalStatus=YES;
        }
        else if (call.callState == CTCallStateConnected)
        {
            DDLog(@"Call has just been connected");
        }
        
        else if(call.callState == CTCallStateIncoming)
        {
            DDLog(@"Call is incoming");
           [commandSend phoneAlarm_send:peripheral];//来电提醒 设置
        }
        
        else if (call.callState ==CTCallStateDialing)
        {
            DDLog(@"call is dialing");
        }
        else
        {
            DDLog(@"Nothing is done");
        }
    };
    
    _deviceBleState = BleManagerStateConnect;
    self.deviceTied = peripheral;
    for (id listener in _listener) {
        if ([listener respondsToSelector:@selector(didConnectDevicePeripheral:)]) {
            [listener didConnectDevicePeripheral:peripheral];
                    }
    }
    
    //因为在后面我们要从外设蓝牙那边再获取一些信息，并与之通讯，这些过程会有一些事件可能要处理，所以要给这个外设设置代理
    peripheral.delegate = self;
    //找到该设备上的指定服务 调用完该方法后会调用代理CBPeripheralDelegate（现在开始调用另一个代理的方法了）
        
//    [peripheral discoverServices:nil];
    
}
- (void)startdiscoverSerVices:(CBPeripheral *)peripheral WithUUID:(NSArray<CBUUID *> *)aryUUID
{
    [peripheral discoverServices:aryUUID];
}
- (void)startdiscoverSerVices:(CBPeripheral*)peripheral
{
//    [peripheral discoverServices:nil];
}

#pragma mark - >> 连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    _deviceBleState = BleManagerStateDisconnect;
    for (id listener in _listener) {
        if ([listener respondsToSelector:@selector(didFailToConnectDevicePeripheral:)]) {
            [listener didFailToConnectDevicePeripheral:peripheral];
        }
    }
    NSLog(@"连接失败:%@", peripheral.name);
}

#pragma mark - >> 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"断开连接:%@", peripheral.name);
    
    for (id listener in _listener) {
        if ([listener respondsToSelector:@selector(didDisconnectDevicePeripheral:)]) {
            [listener didDisconnectDevicePeripheral:peripheral];
        }
    }
    // 重连
//    [self connectDevicePeripheralWithPeripheral:peripheral];
}

#pragma mark - >> CBPeripheralDelegate
#pragma mark - >> 发现服务
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error
{
    if (error) {
        DDLog(@"  发现服务时发生错误: %@",error);
        return;
    }
    DDLog(@" 发现服务 ..");
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
        
    }
}

//- (void)didDiscoverCharacteristicsForServiceperipheral:(CBPeripheral *)peripheral :(CBService *)service error:(NSError *)error;

#pragma mark - >> 发现特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    DDLog(@" 蓝牙管理页面 》》》》》 发现服务 %@, 特性数: %ld", [service.UUID UUIDString], [service.characteristics count]);
    for (CBCharacteristic *c in service.characteristics) {
//        [peripheral readValueForCharacteristic:c];
        //打开心率的notify通道
        DDLog(@" 蓝牙管理页面特征UUID:%@", [c.UUID UUIDString]);
        DDLog(@"特性值： %@",c.UUID);
        DDLog(@"特征：%@",c);
        if([[c.UUID UUIDString] isEqualToString:HEART_READ_UUID])
        {
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }//打开实时计步的通道
        else if([[c.UUID UUIDString] isEqualToString:REALTIME_STEP_UUID])
        {
            //sleep(500);
            [peripheral setNotifyValue:YES forCharacteristic:c];

        }
        //提醒通道的打开
        else if([[c.UUID UUIDString] isEqualToString:WARNING_DATA_READ_UUID])
        {
            //sleep(500);
            [peripheral setNotifyValue:YES forCharacteristic:c];

        }
        //同步通道打开
        else if([[c.UUID UUIDString] isEqualToString:SETPARAM_READ_UUID])
        {
            //sleep(500);
            [peripheral setNotifyValue:YES forCharacteristic:c];

        }
//        计步通道打开
       else if([[c.UUID UUIDString] isEqualToString:SYNC_STEP_DATA_READ_UUID])
        {
            //sleep(500);
//            [peripheral readValueForCharacteristic:c];
            [peripheral setNotifyValue:YES forCharacteristic:c];

        }
        //睡眠通道通道打开
        else if([[c.UUID UUIDString] isEqualToString:SYNC_SLEEP_DATA_READ_UUID])
        {
            //sleep(500);
            [peripheral setNotifyValue:YES forCharacteristic:c];
        }
        else if ([[c.UUID UUIDString ]isEqualToString:@"2A26"]){
            [peripheral readValueForCharacteristic:c];
        }
        
    }
}

#pragma mark - >> 如果一个特征的值被更新，然后周边代理接收
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    DDLog(@"蓝牙管理页面 》》》》》 update Notification");
    for (id listener in _listener) {
        if ([listener respondsToSelector:@selector(didUpdateNotificationStateForCharacteristic:)]) {
            [listener didUpdateNotificationStateForCharacteristic:characteristic];
        }
    }
}

#pragma mark - >> 读数据
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    for (id listener in _listener) {
        if ([listener respondsToSelector:@selector(didUpdateDeviceValueForCharacteristic: error:)]) {
            [listener didUpdateDeviceValueForCharacteristic:characteristic error:error];
        }
    }
    if([[characteristic.UUID UUIDString] isEqualToString:WARNING_DATA_READ_UUID])
    {
        DDLog(@"久坐提醒接 收数据");
        unsigned char* txValue = (unsigned char*)[characteristic.value bytes];
        print_hex_ascii_line(txValue, 20, 0);
        //    DDLog(@" 运动 receiveData = %@,fromCharacteristic.UUID = %@",characteristic.value,characteristic.UUID);
        char retjson[512] = {0};
        parseDateSync(txValue, retjson);
        DDLog(@"long sit json = %s", retjson);
        
        NSString *strData = [NSString stringWithUTF8String:retjson];
        
        NSDictionary *longsitDic = [NSString parseJSONStringToNSDictionary:strData];
        
        if ([[longsitDic objectForKey:@"value"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictRet = [longsitDic objectForKey:@"value"];
            NSString *stringRet = [NSString stringWithFormat:@"您久坐了：%@分钟", [dictRet objectForKey:@"sittime"]];
            
            [self showBackgroundNotification:stringRet];
        }
    }
}
-(void)showBackgroundNotification:(NSString *)message
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertAction = @"Show";
    notification.alertBody = message;
    
    notification.hasAction = NO;
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    notification.timeZone = [NSTimeZone  defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody =  @"久坐提醒";
    notification.applicationIconBadgeNumber = 1;
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",message] forKey:@"key"];
    notification.userInfo = userDict;
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSDayCalendarUnit;
    }
    [[UIApplication sharedApplication] setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    DDLog(@"did write value For Characteristic");
    DDLog(@"value:%@ error:%@", characteristic.value,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    DDLog(@"did Write Value For Descriptor");
}


@end
