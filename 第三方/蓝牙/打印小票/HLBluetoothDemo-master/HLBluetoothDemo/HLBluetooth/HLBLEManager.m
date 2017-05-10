//
//  HLBLEManager.m
//  HLBluetoothDemo
//
//  Created by Harvey on 16/4/27.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import "HLBLEManager.h"

@interface HLBLEManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong, nonatomic)   CBCentralManager            *centralManager;        /**< 中心管理器 */
@property (strong, nonatomic)   CBPeripheral                *connectedPerpheral;    /**< 当前连接的外设 */

@property (strong, nonatomic)   NSArray<CBUUID *>           *serviceUUIDs;          /**< 要查找服务的UUIDs */
@property (strong, nonatomic)   NSArray<CBUUID *>           *characteristicUUIDs;   /**< 要查找特性的UUIDs */

@property (assign, nonatomic)   BOOL             stopScanAfterConnected;  /**< 是否连接成功后停止扫描蓝牙设备 */

@end

static HLBLEManager *instance = nil;

@implementation HLBLEManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HLBLEManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //蓝牙没打开时alert提示框
        NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey:@(YES)};
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:options];
        
    }
    
    return self;
}

- (void)scanForPeripheralsWithServiceUUIDs:(NSArray<CBUUID *> *)uuids options:(NSDictionary<NSString *, id> *)options
{
    [_centralManager scanForPeripheralsWithServices:uuids options:options];
}

- (void)scanForPeripheralsWithServiceUUIDs:(NSArray<CBUUID *> *)uuids options:(NSDictionary<NSString *, id> *)options didDiscoverPeripheral:(HLDiscoverPeripheralBlock)discoverBlock
{
    _discoverPeripheralBlcok = discoverBlock;
    [_centralManager scanForPeripheralsWithServices:uuids options:options];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
           connectOptions:(NSDictionary<NSString *,id> *)connectOptions
   stopScanAfterConnected:(BOOL)stop
          servicesOptions:(NSArray<CBUUID *> *)serviceUUIDs
   characteristicsOptions:(NSArray<CBUUID *> *)characteristicUUIDs
            completeBlock:(HLBLECompletionBlock)completionBlock;
{
    //1.保存回调的block以及参数
    _completionBlock = completionBlock;
    _serviceUUIDs = serviceUUIDs;
    _characteristicUUIDs = characteristicUUIDs;
    _stopScanAfterConnected = stop;
    
    //2.先取消之前连接的蓝牙外设
    if (_connectedPerpheral) {
        [_centralManager cancelPeripheralConnection:_connectedPerpheral];
    }
    
    //3.开始连接新的蓝牙外设
    [_centralManager connectPeripheral:peripheral options:connectOptions];
    //4.设置代理
    peripheral.delegate = self;
}

- (void)discoverIncludedServices:(NSArray<CBUUID *> *)includedServiceUUIDs forService:(CBService *)service
{
    [_connectedPerpheral discoverIncludedServices:includedServiceUUIDs forService:service];
}

- (void)stopScan
{
    [_centralManager stopScan];
}

- (void)cancelPeripheralConnection
{
    if (_connectedPerpheral) {
        [_centralManager cancelPeripheralConnection:_connectedPerpheral];
    }
}

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic
{
    [_connectedPerpheral readValueForCharacteristic:characteristic];
}

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic completionBlock:(HLValueForCharacteristicBlock)completionBlock
{
    _valueForCharacteristicBlock = completionBlock;
    [self readValueForCharacteristic:characteristic];
}

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type
{
    [_connectedPerpheral writeValue:data forCharacteristic:characteristic type:type];
}

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type completionBlock:(HLWriteToCharacteristicBlock)completionBlock
{
    _writeToCharacteristicBlock = completionBlock;
    [self writeValue:data forCharacteristic:characteristic type:type];
}

- (void)readValueForDescriptor:(CBDescriptor *)descriptor
{
    [_connectedPerpheral readValueForDescriptor:descriptor];
}

- (void)readValueForDescriptor:(CBDescriptor *)descriptor completionBlock:(HLValueForDescriptorBlock)completionBlock
{
    _valueForDescriptorBlock = completionBlock;
    [self readValueForDescriptor:descriptor];
}

- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor
{
    [_connectedPerpheral writeValue:data forDescriptor:descriptor];
}

- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor completionBlock:(HLWriteToDescriptorBlock)completionBlock
{
    _writeToDescriptorBlock = completionBlock;
    [self writeValue:data forDescriptor:descriptor];
}

- (void)readRSSICompletionBlock:(HLGetRSSIBlock)getRSSIBlock
{
    _getRSSIBlock = getRSSIBlock;
    [_connectedPerpheral readRSSI];
}


#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCentralManagerStateUpdateNoticiation object:@{@"central":central}];
    
    if (_stateUpdateBlock) {
        _stateUpdateBlock(central);
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (_discoverPeripheralBlcok) {
        _discoverPeripheralBlcok(central, peripheral, advertisementData, RSSI);
    }
}

#pragma mark ---------------- 连接外设成功和失败的代理 ---------------
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _connectedPerpheral = peripheral;
    
    if (_stopScanAfterConnected) {
        [_centralManager stopScan];
    }
    
    if (_discoverServicesBlock) {
        _discoverServicesBlock(peripheral, peripheral.services,nil);
    }
    
    if (_completionBlock) {
        _completionBlock(HLOptionStageConnection,peripheral,nil,nil,nil);
    }
    
    [peripheral discoverServices:_serviceUUIDs];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    if (_discoverServicesBlock) {
        _discoverServicesBlock(peripheral, peripheral.services,error);
    }
    
    if (_completionBlock) {
        _completionBlock(HLOptionStageConnection,peripheral,nil,nil,error);
    }
}

#pragma mark ---------------- 发现服务的代理 -----------------
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    if (error) {
        if (_completionBlock) {
            _completionBlock(HLOptionStageSeekServices,peripheral,nil,nil,error);
        }
        return;
    }
    
    if (_completionBlock) {
        _completionBlock(HLOptionStageSeekServices,peripheral,nil,nil,nil);
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:_characteristicUUIDs forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error
{
    if (error) {
        if (_discoverdIncludedServicesBlock) {
            _discoverdIncludedServicesBlock(peripheral,service,nil,error);
        }
        return;
    }
    
    if (_discoverdIncludedServicesBlock) {
        _discoverdIncludedServicesBlock(peripheral,service,service.includedServices,error);
    }
}

#pragma mark ---------------- 服务特性的代理 --------------------
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
    if (error) {
        if (_completionBlock) {
            _completionBlock(HLOptionStageSeekCharacteristics,peripheral,service,nil,error);
        }
        return;
    }
    
    if (_discoverCharacteristicsBlock) {
        _discoverCharacteristicsBlock(peripheral,service,service.characteristics,nil);
    }
    
    if (_completionBlock) {
        _completionBlock(HLOptionStageSeekCharacteristics,peripheral,service,nil,nil);
    }
    
    for (CBCharacteristic *character in service.characteristics) {
        [peripheral discoverDescriptorsForCharacteristic:character];
    }

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (error) {
        if (_notifyCharacteristicBlock) {
            _notifyCharacteristicBlock(peripheral,characteristic,error);
        }
        return;
    }
    if (_notifyCharacteristicBlock) {
        _notifyCharacteristicBlock(peripheral,characteristic,nil);
    }
}

// 读取特性中的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        if (_valueForCharacteristicBlock) {
            _valueForCharacteristicBlock(characteristic,nil,error);
        }
        return;
    }
    
    NSData *data = characteristic.value;
    if (_valueForCharacteristicBlock) {
        _valueForCharacteristicBlock(characteristic,data,nil);
    }
}

#pragma mark ---------------- 发现服务特性描述的代理 ------------------
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (error) {
        if (_completionBlock) {
            _completionBlock(HLOptionStageSeekdescriptors,peripheral,nil,characteristic,error);
        }
        return;
    }
    
    if (_completionBlock) {
        _completionBlock(HLOptionStageSeekdescriptors,peripheral,nil,characteristic,nil);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error
{
    if (error) {
        if (_valueForDescriptorBlock) {
            _valueForDescriptorBlock(descriptor,nil,error);
        }
        return;
    }
    
    NSData *data = descriptor.value;
    if (_valueForDescriptorBlock) {
        _valueForDescriptorBlock(descriptor,data,nil);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error
{
    if (error) {
        if (_writeToDescriptorBlock) {
            _writeToDescriptorBlock(descriptor, error);
        }
        return;
    }
    
    if (_writeToDescriptorBlock) {
        _writeToDescriptorBlock(descriptor, nil);
    }
}

#pragma mark ---------------- 写入数据的回调 --------------------
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (_writeToCharacteristicBlock) {
        _writeToCharacteristicBlock(characteristic,error);
    }
}

#pragma mark ---------------- 获取信号之后的回调 ------------------

# if  __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    if (_getRSSIBlock) {
        _getRSSIBlock(peripheral,peripheral.RSSI,error);
    }
}
#else
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    if (_getRSSIBlock) {
        _getRSSIBlock(peripheral,RSSI,error);
    }
}
#endif



@end
