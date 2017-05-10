//
//  Gjkm_AlertView.h
//  Gjkm_AltreView
//
//  Created by Gj k m on 16/4/14.
//  Copyright © 2016年 Gj k m. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,GAlertViewStyle) {
    GAlertViewStyleDefault,
    GAlertViewStyleActionSheet,//IOS8.0 以上支持
    GAlertViewStyleText,
    
};

@class GAlertView;

@protocol GAlertViewDeletegate <NSObject>

- (void)AlertView:(GAlertView *)AlertView ButtonclickIndex:(NSInteger)buttonindex;

@end
@interface GAlertView : UIView
@property(nonatomic,weak)id<GAlertViewDeletegate> deletegate;
@property(nonatomic,strong)NSString *  Messagestr;//提示内容
@property(nonatomic,strong)NSString *  Title;//提示标题
@property(nonatomic,strong)NSString *  submiteButtonTitle;//确认按钮

- (instancetype)initWithStyle:(GAlertViewStyle)Style;
+ (instancetype)AlertView;
- (void)show:(UIView *)View;

/*
 CGSize size = [_Messagestr boundingRectWithSize:CGSizeMake((self.frame.size.width/4)*3-Spacing*2 - Spacing/2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Font]} context:nil].size;
 */
@end
