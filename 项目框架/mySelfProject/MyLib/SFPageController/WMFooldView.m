//
//  WMFooldView.m
//  WMPageController
//
//  Created by Mark on 15/7/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMFooldView.h"

@implementation WMFooldView {
    CGFloat WMFooldMargin;
    CGFloat WMFooldRadius;
    CGFloat WMFooldLength;
    CGFloat WMFooldHeight;
    int sign;
    CGFloat gap;
    CGFloat step;
    CADisplayLink *link;
    
    CGFloat kTime;
}
@synthesize progress = _progress;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        WMFooldHeight = frame.size.height;
        WMFooldMargin = WMFooldHeight * 0.15;
        WMFooldRadius = (WMFooldHeight - 2*WMFooldMargin)/2;
        WMFooldLength = frame.size.width  - 2*WMFooldRadius;
        kTime = 20.0;
    }
    return self;
}
- (void)setProgressWithOutAnimate:(CGFloat)progress {
    if (self.progress == progress) return;
    _progress = progress;
    [self setNeedsDisplay];
}
- (void)setProgress:(CGFloat)progress {
    if (self.progress == progress) return;
    if (fabs(progress - _progress) >= 0.9 && fabs(progress - _progress) < 1.5) {
        gap  = fabs(self.progress - progress);
        sign = self.progress>progress?-1:1;
        if (self.itemFrames.count <= 3) {
            kTime = 15.0;
        }
        step = gap / kTime;
        link = [CADisplayLink displayLinkWithTarget:self selector:@selector(progressChanged)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        return;
    }
    _progress = progress;
    [self setNeedsDisplay];
}
- (void)progressChanged {
    if (gap >= 0.0) {
        gap -= step;
        if (gap < 0.0) {
            self.progress = (int)(self.progress+0.5);
            return;
        }
        self.progress += sign * step;
//        gap -= step;
    }else{
        self.progress = (int)(self.progress+0.5);
        [link invalidate];
        link = nil;
    }
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    int currentIndex = (int)self.progress;
    CGFloat rate = self.progress - currentIndex;
    int nextIndex = currentIndex+1 >= self.itemFrames.count ?: currentIndex+1;

    // 当前item的各数值
    CGRect  currentFrame = [self.itemFrames[currentIndex] CGRectValue];
    CGFloat currentWidth = currentFrame.size.width;
    CGFloat currentX = currentFrame.origin.x;
    // 下一个item的各数值
    CGFloat nextWidth = [self.itemFrames[nextIndex] CGRectValue].size.width;
    CGFloat nextX = [self.itemFrames[nextIndex] CGRectValue].origin.x;
    // 计算点
    CGFloat startX = currentX + (nextX - currentX) * rate;
    CGFloat endX = startX + currentWidth + (nextWidth - currentWidth)*rate;
    // 绘制
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0f, WMFooldHeight);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    CGContextAddArc(ctx, startX+WMFooldRadius, WMFooldHeight/2.0, WMFooldRadius, M_PI_2, M_PI_2*3, 0);
    CGContextAddLineToPoint(ctx, endX-WMFooldRadius, WMFooldMargin);
    CGContextAddArc(ctx, endX-WMFooldRadius, WMFooldHeight/2.0, WMFooldRadius, -M_PI_2, M_PI_2, 0);
    CGContextClosePath(ctx);
    
    
    if (self.hollow) {
        CGContextSetStrokeColorWithColor(ctx, self.color);
        CGContextStrokePath(ctx);
        return;
    }
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.color);
    CGContextFillPath(ctx);
}


@end
