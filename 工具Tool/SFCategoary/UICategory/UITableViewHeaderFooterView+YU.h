//
//  UITableViewHeaderFooterView+YU.h
//  YUKit<https://github.com/c6357/YUKit>
//
//  Created by BruceYu on 15/9/7.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewHeaderFooterView (YU)

+(void)registerForTableHeaderFooter:(UITableView*)table;

+(id)XIBViewForTableHeaderFooter:(UITableView*)table;

@end
