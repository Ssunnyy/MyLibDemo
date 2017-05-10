//
//  UIImage+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

- (UIImage *)scaleToSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)compressWithRate:(CGFloat)rate;
/**
 *  中心拉伸一张图片
 *
 *  @param imageName 图片名称
 *
 *  @return 拉伸后的图片
 */
+ (UIImage *)resizableImage:(NSString *)imageName;
/**
 *  自由拉伸一张图片
 *
 *  @param name 图片名字
 *  @param left 左边开始位置比例  值范围0-1
 *  @param top  上边开始位置比例  值范围0-1
 *
 *  @return 拉伸后的Image
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/**
 *  根据颜色和大小获取Image
 *
 *  @param color 颜色
 *  @param size  大小
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/**
 *  根据图片和颜色返回一张加深颜色以后的图片
 */
+ (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;

/**
 *  自由改变Image的大小
 *
 *  @param size 目的大小
 *
 *  @return 修改后的Image
 */
- (UIImage *)cropImageWithSize:(CGSize)size;
/**
 *  图片切圆角得到新图片
 *
 *  @param radius 切角半径
 *
 *  @return 返回的新的圆角图片
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;
/**
 *   图片切圆角得到新图片
 *
 *  @param radius      半径
 *  @param borderWidth 外边宽度
 *  @param borderColor 外边颜色
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;
@end





























