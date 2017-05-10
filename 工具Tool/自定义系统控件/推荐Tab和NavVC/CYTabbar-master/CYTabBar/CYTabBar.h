//
//  CYTabBar.h
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CYCenterButton.h"
@class CYButton;
@class CYTabBar;

@protocol CYTabBarDelegate <NSObject>
@optional
/*! 中间按钮点击会通过这个代理通知你通知 */
- (void)tabbar:(CYTabBar *)tabbar clickForCenterButton:(CYCenterButton *)centerButton;
/*! 默认返回YES，允许所有的切换，不过你通过TabBarController来直接设置SelectIndex来切换的是不会收到通知的。 */
- (BOOL)tabBar:(CYTabBar *)tabBar willSelectIndex:(NSInteger)index;
/*! 通知已经选择的控制器下标。 */
- (void)tabBar:(CYTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end

@interface CYTabBar : UIView
/** tabbar按钮显示信息 */
@property(copy, nonatomic) NSArray<UITabBarItem *> *items;
/** 其他按钮 */
@property (strong , nonatomic) NSMutableArray <CYButton*>*btnArr;
/** 中间按钮 */
@property (strong , nonatomic) CYCenterButton *centerBtn;
/** 委托 */
@property(weak , nonatomic) id<CYTabBarDelegate>delegate;

@end
