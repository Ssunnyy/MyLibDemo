//
//  TMNavigationViewController.h
//  Demo
//
//  Created by TianMing on 16/3/10.
//  Copyright © 2016年 TianMing. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SFNavigationController : UINavigationController
@end

typedef void(^clickBackButton)(UIButton * button);
@interface navigationBarView : UIView
@property (copy ,nonatomic) clickBackButton click;
-(void)clickBackButton:(clickBackButton)block;
@property (copy ,nonatomic) NSString * title;
@property (strong ,nonatomic)UILabel * titleLabel;
@property (strong ,nonatomic)UIButton * backButton;
-(instancetype)initWithFrame:(CGRect)frame;
@end

@interface UIViewController (navigationBar)
@property (nonatomic,strong) navigationBarView *navigationBar;
@property (nonatomic,getter=isNavigationBar)BOOL navigationBarHidden;
@property(nonatomic,copy)NSString *title;
@property (nonatomic,strong) UIColor * navigationBarBackgroundColor;

@end