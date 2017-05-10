//
//  NearbyPeripheralInfo.h
//  HealthGuard
//
//  Created by LaoTao on 15/11/26.
//  Copyright © 2015年 LaoTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NearbyPeripheralInfo : NSObject

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSDictionary *advertisementData;
@property (nonatomic,copy) NSString *showName;
@property (strong, nonatomic) NSNumber *RSSI;


@end
