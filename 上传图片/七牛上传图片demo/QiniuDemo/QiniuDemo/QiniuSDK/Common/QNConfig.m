//
//  QNConfig.m
//  QiniuSDK
//
//  Created by bailong on 14/10/3.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import "QNConfig.h"

NSString *const kQNUpHost = @"upload.qiniu.com";

NSString *const kQNUpHostBackup = @"up.qiniu.com";

NSString *const kQNUpSrcIP1 = @"183.136.139.16";

// todo 通过API 判断手机网络运营商，选择联通IP99
NSString *const kQNUpSrcIP2 = @"101.71.78.240";

const UInt32 kQNChunkSize = 256 * 1024;

const UInt32 kQNBlockSize = 4 * 1024 * 1024;

const UInt32 kQNPutThreshold = 512 * 1024;

const UInt32 kQNRetryMax = 3;

const float kQNTimeoutInterval = 30.0;
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com