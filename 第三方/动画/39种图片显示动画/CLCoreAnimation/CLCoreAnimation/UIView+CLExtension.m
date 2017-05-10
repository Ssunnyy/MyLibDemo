//
//  UIView+CLExtension.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/21.
//  Copyright © 2016年 More. All rights reserved.
//

#import "UIView+CLExtension.h"

@implementation UIView (CLExtension)

-(void)setSize:(CGSize)size
{
    CGRect frame =self.frame;
    frame.size = size;
    self.frame =frame;
}
-(CGSize)size{
    return self.frame.size;
}

/**
 width
 */
-(void)setWidth:(CGFloat)width
{
    CGRect frame =self.frame;
    frame.size.width =width;
    self.frame =frame;
}
-(CGFloat)width
{
    return self.frame.size.width;
    
}

/**
 height
 */
-(void)setHeight:(CGFloat)height
{
    CGRect frame =self.frame;
    frame.size.height =height;
    self.frame =frame;
}
-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setCenterX:(CGFloat)centerX{
    CGPoint center =self.center;
    center.x =centerX;
    self.center =center;
}
-(CGFloat)centerX{
    return self.center.x;
}


-(void)setCenterY:(CGFloat)centerY
{
    CGPoint  center =self.center;
    center.y = centerY;
    self.center =center;
}
-(CGFloat)centerY{
    return self.center.y;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

@end
