//
//  WirteDataToBluetooth.m
//  HBGuard
//
//  Created by 李帅 on 16/1/22.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import "WriteDataToBluetooth.h"

@implementation WriteDataToBluetooth

+ (void)writeToperipheral:(CBPeripheral *)peripheral Service:(NSString *)serviceUUID characteristic:(NSString *)characteristicUUID data:(NSData *)data
{
    CBUUID *servUUID = [CBUUID UUIDWithString:serviceUUID];
    CBUUID *charUUID = [CBUUID UUIDWithString:characteristicUUID];
    CBService *service = nil;
    CBCharacteristic *characteristic = nil;
    for (CBService *ser in peripheral.services) {
        if ([ser.UUID isEqual:servUUID]) {
            service = ser;
            break;
        }
    }
    if (service) {
        for (CBCharacteristic *charac in service.characteristics) {
            if ([charac.UUID isEqual:charUUID]) {
                characteristic = charac;
                break;
            }
        }
    }
    if (characteristic) {
        [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    else{
        NSLog(@"not found that characteristic");
    }
}

@end
