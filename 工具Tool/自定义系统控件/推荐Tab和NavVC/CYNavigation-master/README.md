# CYNavigation
[![](https://img.shields.io/travis/rust-lang/rust.svg?style=flat)](https://github.com/zhangchunyu2016/CYNavigation)
[![](https://img.shields.io/badge/language-Object--C-1eafeb.svg?style=flat)](https://developer.apple.com/Objective-C)
[![](https://img.shields.io/badge/license-MIT-353535.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://github.com/zhangchunyu2016/CYNavigation)
[![](https://img.shields.io/badge/Pod-v1.0.0-blue.svg?style=flat)](https://cocoapods.org/?q=cytabbar)
[![](https://img.shields.io/badge/QQ-707214577-red.svg)](http://wpa.qq.com/msgrd?v=3&uin=707214577&site=qq&menu=yes)


</br>
<p>同样做为基础的组件，这个导航控制器我已经用了很久，希望能帮助到你。</p></br>
<img src="http://upload-images.jianshu.io/upload_images/2028853-368b7e847f6f733e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/320"style="display: inline-block"></br>

## 一.  功能简介 - Introduction

- [x] 每个viewController单独维护一个navigationBar
- [x] 可单独禁止某页返回手势   
- [x] 便捷的UI配置
- [x] 全屏返回
- [x] 类似淘票票的转场动画(你可以自定义) 

## 二.  安装 - Installation

##### 方式1:CocoaPods安装
```
pod 'CYNavigation'
```


##### 方式2:手动导入
```
直接将项目中的“CYNavigation”文件夹的源文件 拖入项目中
```

##### 你可以这样来设置你的NavigationController
```
#import "CYNavigationController.h"头文件后

/*! 初始化控制器 */
CYNavigationController *nav = [[CYNavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];

/*! 配置默认UI */
[CYNavigationConfig shared].backgroundColor = [UIColor orangeColor];
[CYNavigationConfig shared].fontColor = [UIColor whiteColor];
[CYNavigationConfig shared].leftBtnImageColor = [UIColor redColor];
[CYNavigationConfig shared].borderHeight = 0.5;
[CYNavigationConfig shared].backGesture = ^UIPanGestureRecognizer *{
    return [[UIPanGestureRecognizer alloc]init];
}; //全屏返回
[CYNavigationConfig shared].transitionAnimationClass = NSClassFromString(@"HighlightTransitionAnimation");//凸显的过渡动画
//等.....

/*! 为viewController设置navigationBar */
self.navigationbar = [self standardNavigationbar];
self.navigationbar.title.text = @"首页";
[self.navigationbar.rightBtn setTitle:@"下一页" forState:UIControlStateNormal];
self.navigationbar.rightBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];

```


## 三.  要求 - Requirements

- ARC环境. - Requires ARC


## 四.  更新历史 - Update History

暂无		  

## 五.  更多 - More

- 如果你发现任何Bug 或者 新需求请issue我.

- 大家一起讨论一起学习进步.
  
