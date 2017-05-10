//
//  ViewController.m
//  Gjkm_AltreView
//
//  Created by Gj k m on 16/4/14.
//  Copyright © 2016年 Gj k m. All rights reserved.
//

#import "ViewController.h"
#import "GAlertView.h"

@interface ViewController () <GAlertViewDeletegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GAlertView * alertView = [[GAlertView alloc]initWithStyle:GAlertViewStyleDefault];
    alertView.Messagestr = @"我们";
    alertView.deletegate = self;
    alertView.submiteButtonTitle = @"确定";
    [alertView show:self.view];
    
}
- (void)AlertView:(GAlertView *)AlertView ButtonclickIndex:(NSInteger)buttonindex{
    if (buttonindex == 1) {//点击了确定
        
        NSLog(@"点击了确定 === %@",AlertView.Messagestr);
    } else {
        NSLog(@"点击了取消 === %@",AlertView.Messagestr);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
