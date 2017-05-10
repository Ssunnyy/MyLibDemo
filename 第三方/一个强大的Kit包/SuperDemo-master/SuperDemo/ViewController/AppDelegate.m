//
//  AppDelegate.m
//  SuperDemo
//
//  Created by tanyugang on 15/4/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "CommonHeader.h"

#import "UncaughtExceptionHandler.h"
#import "MYBlurIntroductionDemo.h"
#import "DEMOMenuViewController.h"

#import <FBMemoryProfiler/FBMemoryProfiler.h>
#import "RetainCycleLoggerPlugin.h"
#import "CacheCleanerPlugin.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    FBMemoryProfiler *_memoryProfiler;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //捕捉意外崩溃
    [UncaughtExceptionHandler InstallUncaughtExceptionHandler];

    //初始化
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[MainViewController alloc] init];
    }
    else{
        self.viewController = [[MainViewController alloc] init];
    }

    //设置状态栏风格--需要配合配置表
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //侧边菜单
    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:self.viewController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.menuViewSize = CGSizeMake(SCREEN_WIDTH * 0.75, SCREEN_HEIGHT);
//    frostedViewController.delegate = self;
    [self.window addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    self.frostedViewController = frostedViewController;
    
    //首次运行时的引导图
//    MYBlurIntroductionDemo *loadingView = [[MYBlurIntroductionDemo alloc] init];
//    [self.viewController.view addSubview:loadingView.view];
    
    self.window.rootViewController = frostedViewController;
//    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //Facebook内存循环引用监测工具，若APP运行比较卡，请关闭此部分
    _memoryProfiler = [[FBMemoryProfiler alloc] initWithPlugins:@[[CacheCleanerPlugin new],
                                                                  [RetainCycleLoggerPlugin new]]
                               retainCycleDetectorConfiguration:nil];
    [_memoryProfiler enable];
    
    return YES;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.window endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//禁用第三方输入法
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    //禁用第三方输入法
    return NO;
}

@end
