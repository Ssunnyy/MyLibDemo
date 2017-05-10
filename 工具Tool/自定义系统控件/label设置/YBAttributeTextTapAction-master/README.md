# YBAttributeTextTapAction
 * 一行代码添加文本点击事件

# 效果图
![(演示效果)](http://7xt3dd.com1.z0.glb.clouddn.com/attributeAction.gif)

# Swfit版本（已更新至swfit3.0）
https://github.com/lyb5834/YBAttributeTextTapForSwfit.git

#使用方法
  * `#import "UILabel+YBAttributeTextTapAction.h"`
  * 设置 `label.attributedText = ？？？？？` 
  * 有2种回调方法，第一种是用代理回调，第二种是用block回调
  * 第一种 `[label yb_addAttributeTapActionWithStrings:@[@"xxx",@"xxx"] delegate:self];` 
  * 第二种 `[label yb_addAttributeTapActionWithStrings:@[@"xxx",@"xxx"] tapClicked:^(NSString *string, NSRange range,NSInteger index) {  coding more... }];`
  * PS:数组里输入的要点击的字符可以重复

#CocoaPods支持
  * 只需在podfile中输入 `pod 'YBAttributeTextTapAction'` 即可

#V2.0.5修复
  * 修复内存泄漏

#V2.0.0重大更新
  * 修复字体变小时，坐标计算不正确导致无法点击的bug

#V2.1.0更新
  * 增加点击效果，默认是开启，关闭只需设置`label.enabledTapEffect = NO`即可

#重要提醒
  * 使用本框架时，最好设置一下`NSParagraphStyle中`的`lineSpacing`属性，也就是行间距，如果不设置，则默认为0！
  * 使用本框架时，一定要设置`label.attributedText = ？？？？？` ，不设置则无效果！！
  
#问题总结
  *  因为UILabel的封装，有些属性不能实现，在此说一下一些提的比较多的问题
  1. 关于文字排版的正确设置方式，设置`label.textAlignment = NSTextAlignmentCenter`会导致点击失效，正确的设置方法是`NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
     sty.alignment = NSTextAlignmentCenter;
     [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, text.length)];`
  2. 务必查看下是否设置了`NSFontAttributeName`这个属性，不设置的话，coreText上下文获取不到font属性，更别提计算了准确了

#版本支持
  * `xcode6.0+`

  * 如果您在使用本库的过程中发现任何bug或者有更好建议，欢迎联系本人email  lyb5834@126.com

