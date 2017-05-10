//
//  AppDelegate.m
//  LCNewFeatureDemo
//
//  Created by 刘超 on 15/4/30.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "AppDelegate.h"
#import "LCNewFeatureVC.h"

// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface AppDelegate () <LCNewFeatureVCDelegate> {
    
    /** 新特性界面 (如果是通过 Block 方式进入主界面则不需要声明该属性) */
    LCNewFeatureVC *_newFeatureVC;
}

@end

@implementation AppDelegate

#pragma mark - 快速集成方法如下:(请务必阅读`LCNewFeatureVC.h`顶部的`必读`)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
#pragma mark 1. 是否应该显示新特性界面
    
    BOOL showNewFeature = [LCNewFeatureVC shouldShowNewFeature];
    
    // 演示--每次都进入新特性界面, 实际项目不需要此句代码
    showNewFeature = YES;
    
    if (showNewFeature) {   // 如果需要显示新特性界面
        __weak typeof(self) weakSelf = self;
        
#pragma mark 2.1. 方式一: 点击添加的按钮进入主界面
        
        
        // 进入主界面按钮
        UIButton *enterBtn = [[UIButton alloc] init];
        [enterBtn setBackgroundColor:[UIColor redColor]];
        [enterBtn setTitle:@"进入主界面" forState:UIControlStateNormal];
        [enterBtn setFrame:(CGRect){10.0f, SCREEN_SIZE.height * 0.82, SCREEN_SIZE.width - 20.0f, 40.0f}];
        [enterBtn addTarget:self action:@selector(didClickedBtn) forControlEvents:UIControlEventTouchUpInside];
        
        LCNewFeatureVC *newFeatureVC = [LCNewFeatureVC newFeatureWithImageName:@"new_feature"
                                                                    imageCount:3
                                                                showPageControl:YES
                                                                   enterButton:enterBtn];
        newFeatureVC.showSkip = YES;
        newFeatureVC.skipBlock = ^(void) {
            [weakSelf didClickedBtn];
        };
        _newFeatureVC = newFeatureVC;
        
#pragma mark 2.2. 方式二: 一直左划进入主界面
        
        /*
        LCNewFeatureVC *newFeatureVC = [LCNewFeatureVC newFeatureWithImageName:@"new_feature"
                                                                    imageCount:3
                                                               showPageControl:YES
                                                                   finishBlock:^{
                                                                       
                                                                       [weakSelf enterMainVC];
                                                                   }];
        */
        
#pragma mark 3. 设置新特性界面的属性(可选步骤)
        
        // 当前页码的代理
        newFeatureVC.delegate = self;
        
        // 当前点颜色, 默认[UIColor darkGrayColor]
        newFeatureVC.pointCurrentColor = [UIColor redColor];
        
        // 其他点颜色, 默认[UIColor lightGrayColor]
        // newFeatureVC.pointOtherColor = [UIColor orangeColor];
        
        // 状态栏样式, 默认LCStatusBarStyleBlack
        // newFeatureVC.statusBarStyle = LCStatusBarStyleWhite;
        
#pragma mark 4. 设置新特性界面为当前窗口的根视图控制器
        
        self.window.rootViewController = newFeatureVC;
        
    } else {    // 如果不需要显示新特性界面
        
        [self enterMainVC];
    }
    
    
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 点击了进入主界面的按钮

- (void)didClickedBtn {
    
    [self enterMainVC];
}

#pragma mark - 进入主界面

- (void)enterMainVC {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self restoreRootViewController:storyboard.instantiateInitialViewController];
}

- (void)restoreRootViewController:(UIViewController *)rootViewController {
    
    [UIView transitionWithView:self.window duration:0.7f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        self.window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
        
    } completion:nil];
}

#pragma mark - LCNewFeatureVC Delegate

/**
 *  代理方法，回调当前页码
 *
 *  @param newFeatureVC 控制器
 *  @param page         当前页码
 */
- (void)newFeatureVC:(LCNewFeatureVC *)newFeatureVC page:(NSInteger)page {
    NSLog(@"%@ -> Page: %d", newFeatureVC, (int)page);
}

@end
