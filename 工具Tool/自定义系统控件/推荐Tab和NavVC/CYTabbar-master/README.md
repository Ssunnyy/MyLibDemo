# CYTabBar
[![](https://img.shields.io/travis/rust-lang/rust.svg?style=flat)](https://github.com/zhangchunyu2016/CYTabbar)
[![](https://img.shields.io/badge/language-Object--C-1eafeb.svg?style=flat)](https://developer.apple.com/Objective-C)
[![](https://img.shields.io/badge/license-MIT-353535.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://github.com/zhangchunyu2016/CYTabbar)
[![](https://img.shields.io/badge/Pod-v1.0.0-blue.svg?style=flat)](https://cocoapods.org/?q=cytabbar)
[![](https://img.shields.io/badge/QQ-707214577-red.svg)](http://wpa.qq.com/msgrd?v=3&uin=707214577&site=qq&menu=yes)


</br>
<p>这是一个很好用的底部控制器,已经跟我经历了2个项目，做为基础的组件，希望能帮助到你。</p></br>
<img src="http://upload-images.jianshu.io/upload_images/2028853-deab948167f6ddb3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"></br>
<img src="http://upload-images.jianshu.io/upload_images/2028853-3ad54ef949ad7cbe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/320"></br>

## 一.  功能简介 - Introduction

- [x] 中间按钮可凸出  					--->  bulge设为YES 否则不突出
- [x] 中按钮可设置控制器 或 普通按钮		---> Controller传入nil为普通按钮
- [x] 二级页面不显示tababr 
- [x] 小红点提醒角标  					---> 当前控制器.tabBarItem.badgeValue = @"remind";
- [x] 数字提醒角标 						---> 当前控制器.tabBarItem.badgeValue = @"100";
- [x] 切换控制器  						---> 当前tabBarController.selectedIndex = x(索引为添加控制器时的顺序);
- [x] 改变数字提醒背景颜色 				---> 当前控制器.tabBarItem.badgeColor = [UIColor xxxColor];
- [x] 方便更改默认选择的控制器  			---> [CYTabBarConfig shared].selectIndex = 1;
- [x] 统一的定制UI 						---> [CYTabBarConfig shared].xxx = xxx;
- [x] tabBar代理通知常用事件

## 二.  安装 - Installation

##### 方式1:CocoaPods安装
```
pod 'CYTabBar'
```


##### 方式2:手动导入
```
直接将项目中的“CYTabBar”文件夹的源文件 拖入项目中
```

##### 你可以这样来设置你的tabbar
```
需要导入头文件 "CYTabBarController.h" 
然后在AppDelegate.m中初始化


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    CYTabBarController * tabbar = [[CYTabBarController alloc]init];
    [tabbar addChildController:[ViewController new] title:@"xx" imageName:@"xx" selectedImageName:@"xx"];
    [tabbar addChildController:[ViewController2 new] title:@"xx" imageName:@"xx" selectedImageName:@"xx"];
    [tabbar addCenterController:nil bulge:YES title:@"xx" imageName:@"xx" selectedImageName:@"xx"];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    return YES;
}
```


## 三.  要求 - Requirements

- ARC环境. - Requires ARC


## 四.  更新历史 - Update History

- 2017.03.12  修复tabbar销毁的时候观察者移除问题
- 2017.03.31  修复子控制器未添加时tabbar懒加载带来的问题
- 2017.04.05  修复更新提醒角标UI更新不及时问题
- 2017.04.10  修复设置导航栏为不透明后，坐标偏移问题(Bug 由 QQ用户龙卷风发现)
- 2017.04.18  增加Hiddentabbar的控制器方法，并将tabbar中间按钮点击方法委托出去(issue by star5cbh )
- 2017.05.05  修复部分小问题，增加统一配置UI的单例。 增加默认选择控制器的属性，增加代理通知切换控制器方法。(issue by HY-Vae )
			  

## 五.  更多 - More

- 如果你发现任何Bug 或者 新需求请issue我.

- 大家一起讨论一起学习进步.
  
