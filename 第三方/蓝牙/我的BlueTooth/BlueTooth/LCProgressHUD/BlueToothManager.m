//
//  BlueToothManager.m
//  BlueToothTest
//
//  Created by soft-angel on 15/12/28.
//  Copyright © 2015年 soft－angel. All rights reserved.
//

#import "BlueToothManager.h"
#import "NearbyPeripheralInfo.h"

@implementation BlueToothManager

//创建单例类
+(instancetype)getInstance
{
    static BlueToothManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BlueToothManager alloc]init];
        
    });
    return manager;
    
}

//开始扫描
- (void)startScan
{
    [LCProgressHUD showLoadingText:@"正在扫描"];
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerRestoredStateScanOptionsKey:@(YES)}];
    
    _peripheralList = [[NSMutableArray alloc]initWithCapacity:0];
    _peripheralInfo = [[NSMutableArray alloc]initWithCapacity:0];
}

//停止扫描
-(void)stopScan
{
    [_manager stopScan];
    
}

//检查蓝牙信息
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"蓝牙打开，开始扫描");
        [central scanForPeripheralsWithServices:nil options:nil];
    }
    else
    {
        NSLog(@"蓝牙不可用");
    }
}

//扫描到的设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@===%@",peripheral.name,RSSI);
    [_peripheralList addObject:peripheral];
    [LCProgressHUD hide];
    
    NearbyPeripheralInfo *infoModel = [[NearbyPeripheralInfo alloc] init];
    infoModel.peripheral = peripheral;
    infoModel.advertisementData = advertisementData;
    infoModel.showName = peripheral.name;
    infoModel.RSSI = RSSI;
    [_peripheralInfo addObject:infoModel];
}
-(NSMutableArray *)peripheralInfo{
    return _peripheralInfo;
}
-(NSMutableArray *)servicesInfo{
    return _servicesInfo;
}
-(NSMutableArray *)characteristicsInfo{
    return _characteristicsInfo;
}
//获取扫描到设备的列表
-(NSMutableArray *)getNameList
{
    return _peripheralList;
}

//连接设备
-(void)connectPeripheralWith:(CBPeripheral *)per
{
    [_manager connectPeripheral:per options:nil];
}

//连接设备失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@\n\n",[peripheral name],[error localizedDescription]);
}

//设备断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>外设连接断开连接 %@: %@\n\n", [peripheral name], [error localizedDescription]);
}

//连接设备成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接到 %@ 成功\n\n",peripheral.name);
    _per = peripheral;
    [_per setDelegate:self];
    [_per discoverServices:nil];

}

//扫描设备的服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    _servicesInfo = [[NSMutableArray alloc]initWithCapacity:0];
    if (error)
    {
        NSLog(@"扫描%@的服务发生的 错 误 是：%@\n\n",peripheral.name,[error localizedDescription]);

    }
    else
    {
        for (CBService * ser in peripheral.services)
        {
            NSLog(@"扫描%@的服务为：%@\n\n",peripheral.name,ser.UUID);
//            NSString * str = [NSString stringWithFormat:@"%@",ser.UUID];
            [_servicesInfo addObject:ser];

        }

    }
}
- (void)starSaomiaoTezheng:(CBService *)ser{
    
    [_per discoverCharacteristics:nil forService:ser];
    NSLog(@"开始扫描\n %@ \n服务的所有特征UUID",ser.UUID);

}
//扫描服务的特征值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    _characteristicsInfo = [[NSMutableArray alloc]initWithCapacity:0];
    if (error)
    {
        NSLog(@"扫描服务：%@的特征值的 错 误 是：%@\n\n",service.UUID,error);
    }
    else
    {
        for (CBCharacteristic * cha in service.characteristics)
        {
            NSLog(@"扫描服务：%@的特征值为：%@\n\n",service.UUID,cha.UUID);
//            NSString * str = [NSString stringWithFormat:@"%@",cha.UUID];
            [_characteristicsInfo addObject:cha];
            
        }
    }
}
- (void)starSaomiaoTezhengxinxi:(CBCharacteristic *)cha{

    _char = cha;
    _readChar = cha;
    
    [self openNotify];
    
    [_per readValueForCharacteristic:cha];
    [_per discoverDescriptorsForCharacteristic:cha];
}
//获取特征值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"获取特征值%@的 错 误 为%@\n\n",characteristic.UUID,error);
    }
    else
    {
        NSString *str = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"=00== %@ ===",str);
        NSLog(@"特征值：%@  value：%@\n\n",characteristic.UUID,characteristic.value);
        _responseData = characteristic.value;

    }
}

//扫描特征值的描述
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"搜索到%@的Descriptors的 错 误 是：%@\n\n",characteristic.UUID,error);

    }
    else
    {
        NSLog(@"characteristic uuid:%@\n\n",characteristic.UUID);

        for (CBDescriptor * d in characteristic.descriptors)
        {
            NSLog(@"Descriptor uuid:%@\n\n",d.UUID);

        }
    }
    //当消息接收完全后  此方法可发送关闭请求的消息
//    [self sendDataWithString:d.UUID];
}

//获取描述值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    //当向蓝牙发送完消息后   此方法开始接收消息
    if (error)
    {
        NSLog(@"获取%@的描述的 错 误 是：%@\n\n",peripheral.name,error);
    }
    else
    {
        NSLog(@"characteristic uuid:%@  value:%@\n\n",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);

    }
}

//像蓝牙发送信息
- (void)sendDataWithString:(NSString *)str
{
    NSLog(@"str == %@",str);
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", data);
    if (_per && _char)
    {
        switch (_char.properties & 0x04) {
            case CBCharacteristicPropertyWriteWithoutResponse:
            {
                [_per writeValue:data forCharacteristic:_char type:CBCharacteristicWriteWithoutResponse];
                break;

            }
            default:
            {
                [_per writeValue:data forCharacteristic:_char type:CBCharacteristicWriteWithResponse];
                break;

            }
        }
        
    }

}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error

{
    
    
}

//展示蓝牙返回的信息
-(void)showResult
{
    Byte  byte[] = {0x70,0x20,0x20};
    NSData * data = [NSData dataWithBytes:byte length:3];
    if ([_responseData isEqualToData:data])
    {
        [LCProgressHUD showSuccessText:@"开锁成功"];
        [NSTimer scheduledTimerWithTimeInterval:0.5f
                                         target:self
                                       selector:@selector(hideHUD)
                                       userInfo:nil
                                        repeats:NO];
        
    }

}

//隐藏HUD
- (void)hideHUD {
    
    [LCProgressHUD hide];
}

//打开通知
-(void)openNotify
{
    [_per setNotifyValue:YES forCharacteristic:_readChar];
}

//关闭通知
-(void)cancelNotify
{
    [_per setNotifyValue:NO forCharacteristic:_readChar];

}

//断开连接
-(void)cancelPeripheralWith:(CBPeripheral *)per
{
    [_manager cancelPeripheralConnection:_per];
    
}

@end
