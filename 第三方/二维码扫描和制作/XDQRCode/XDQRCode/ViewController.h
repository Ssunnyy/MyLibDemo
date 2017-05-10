 //
//  ViewController.h
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scaningResultsLabel;

@end

@interface ViewController ()
@property (copy, nonatomic) NSString *extentionTitle;

@end