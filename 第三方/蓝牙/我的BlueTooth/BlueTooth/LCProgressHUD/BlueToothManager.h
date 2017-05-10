//
//  BlueToothManager.h
//  BlueToothTest
//
//  Created by soft-angel on 15/12/28.
//  Copyright © 2015年 soft－angel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "LCProgressHUD.h"

@interface BlueToothManager : NSObject
<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager * _manager;
    CBPeripheral * _per;
    CBCharacteristic * _char;
    CBCharacteristic * _readChar;
    
    NSMutableArray * _peripheralList;
    NSData * _responseData;
    
    NSMutableArray *_peripheralInfo;//所有设备信息详情
    NSMutableArray *_servicesInfo;//某设备所有服务
    NSMutableArray *_characteristicsInfo;//某服务所有特征
}

/**
 *  创建BlueToothManager单例
 *
 *  @return BlueToothManager单例
 */
+(instancetype)getInstance;

/**
 *  开始扫描
 */
- (void)startScan;

/**
 *  停止扫描
 */
-(void)stopScan;

/**
 *  获得设备列表
 *
 *  @return 设备列表
 */
-(NSMutableArray *)getNameList;

/**
 *  连接设备
 *
 *  @param per 选择的设备
 */
-(void)connectPeripheralWith:(CBPeripheral *)per;

/**
 *  打开通知
 */
-(void)openNotify;

/**
 *  关闭停止
 */
-(void)cancelNotify;

/**
 *  发送信息给蓝牙
 *
 *  @param str 遵循通信协议的设定
 */
- (void)sendDataWithString:(NSString *)str;

/**
 *  展示蓝牙返回的结果
 */
-(void)showResult;

/**
 *  断开连接
 *
 *  @param per 连接的per
 */
-(void)cancelPeripheralWith:(CBPeripheral *)per;

//设备信息详情   返回_peripheralInfo 的model数组
-(NSMutableArray *)peripheralInfo;
//某设备所有服务
-(NSMutableArray *)servicesInfo;

- (void)starSaomiaoTezheng:(CBService *)ser;

//某服务所有特征  CBCharacteristic
-(NSMutableArray *)characteristicsInfo;

- (void)starSaomiaoTezhengxinxi:(CBCharacteristic *)cha;

@end
