//
//  CentralManager.h
//  HealthGuard
//
//  Created by LaoTao on 15/11/2.
//  Copyright © 2015年 LaoTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "NearbyPeripheralInfo.h"
#import "AppDelegate.h"
#import "BlueToothViewTipView.h"
#import "packetProtoUtil.h"
#import "parseProtoUtil.h"
#import "bitUtil.h"
#import <stdlib.h>
#import "commandSend.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#import "WriteDataToBluetooth.h"

extern BOOL IsBlueToothOpen;
/**
 *  设备连接状态
 */
typedef NS_ENUM(NSInteger, BleManagerState) {
    /**
     * 未连接
     */
    BleManagerStateDisconnect = 0,
    
    /**
     * 已连接
     */
    BleManagerStateConnect,
};

@protocol CentralManagerDelegate <NSObject>

@optional

/**
 *  蓝牙未开启 或 不可用
 */
- (void)centralManagerStatePoweredOff;

//***************************
//****设备
//***************************
/**
 *  发现设备
 */
- (void)didDiscoverDevicePeripheral:(CBPeripheral *)peripheral devices:(NSMutableArray *)deviceArray;  //发现设备

/**
 *  开始连接
 */
- (void)didStartConnectDevicePeripheral;

/**
 *  断开连接
 */
- (void)didCancelDevicePeripheralConnection;

/**
 *  发现的特征值
 */
- (void)didDiscoverDevicePeripheral:(CBPeripheral *)peripheral service:(CBService *)service;

/**
 *  连接成功
 */
- (void)didConnectDevicePeripheral:(CBPeripheral *)peripheral;
/**
 *  连接失败
 */
- (void)didFailToConnectDevicePeripheral:(CBPeripheral *)peripheral;

/**
 *  断开连接
 */
- (void)didDisconnectDevicePeripheral:(CBPeripheral *)peripheral;

/**
 *  连接超时
 */
- (void)didConnectionDeviceTimeOut;

- (void)didDiscoverCharacteristicsForperipheral:(CBPeripheral *)peripheral Service:(CBService *)service error:(NSError *)error;

/**
 *  接收到数据
 */

- (void)didUpdateDeviceValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error ; // deviceData:(NSData *)deviceData;

/**
 *  如果一个特征的值被更新，然后周边代理接收
 *
 *  @param characteristic
 */
- (void)didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic;

//-(void)onReceivedNotification:(NSData *)data;

//-(void)onReadDfuVersion:(int)version;

@end


@interface CentralManager : NSObject
{
    CBPeripheral *_devicePeripheral;    //设备
    CBCharacteristic *_deviceCharacteristic;    //设备服务特征 （用来发送指令）
//    CBCentralManager *_manager; //
    NSMutableArray *_deviceArray;
    
}
+ (BOOL)isBlueOpen;
/**
 * 设备管理 单利
 */
+ (CentralManager *)sharedManager;
/**
 *  验证蓝牙是否可用
 */
- (BOOL)verifyCentralManagerState;

/**
 * 连接状态
 */
@property (assign, nonatomic) BleManagerState deviceBleState;
@property (strong,nonatomic)CBCentralManager *manager;

@property (strong,nonatomic) CBPeripheral *deviceTied;

@property (strong, nonatomic) CBCharacteristic *dfuPacketCharacteristic;
@property (strong, nonatomic) CBCharacteristic *dfuControlPointCharacteristic;
@property (strong, nonatomic) CBCharacteristic *dfuVersionCharacteristic;


@property (strong,nonatomic)CTCallCenter *callCentter;


/**
 * 添加监听
 */
- (void)addEventListener:(id <CentralManagerDelegate>)listener;

/**
 * 删除监听
 */
- (void)removeEventListener:(id <CentralManagerDelegate>)listener;

/**
 *  删除所有监听
 */
- (void)removeAllEventListener;

/**
 * 取消所有蓝牙连接
 */
- (void)cancelPeripheralConnection;

/**
 * 取消蓝牙搜索
 */
- (void)stopManagerScan;

//***************************
//****设备
//***************************

/**
 * 搜索设备
 */
- (void)searchDeviceModule;

/**
 *  连接设备
 *
 *  @param peripheral 设备
 */
- (void)connectDevicePeripheralWithPeripheral:(CBPeripheral *)peripheral;
/**
 *  开始扫描服务
 *
 *  @param peripheral 设备
 */
- (void)startdiscoverSerVices:(CBPeripheral*)peripheral WithUUID:(NSArray<CBUUID*>*)aryUUID;
- (void)startdiscoverSerVices:(CBPeripheral*)peripheral;

@end

