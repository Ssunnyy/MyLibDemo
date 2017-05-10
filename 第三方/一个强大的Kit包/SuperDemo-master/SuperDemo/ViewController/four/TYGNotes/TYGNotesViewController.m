//
//  TYGNotesViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/18.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGNotesViewController.h"

@interface TYGNotesViewController (){
    NSMutableArray *titleArray;
}

@end

@implementation TYGNotesViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        titleArray = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [titleArray addObject:@"iOS地图包-TYGMapKitViewController"];
    [titleArray addObject:@"UrlSchemeMap-TYGUrlSchemeMapViewController"];
    [titleArray addObject:@"版本检测-TYGAppVersionViewController"];
    
    [titleArray addObject:@"IBInspectable-TYGIBViewController"];
    [titleArray addObject:@"自定义不规则按钮点击事件的响应区域-TYGUIButtonViewController"];
    [titleArray addObject:@"正则验证-TYGValidViewController"];
    [titleArray addObject:@"手势签名-TYGSignatureViewDemoViewController"];
    
    [titleArray addObject:@"Masonry学习-TYGMasonryTestViewController"];
    [titleArray addObject:@"图片操作-UIImageOperationViewController"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdetify = @"FourTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = [titleArray objectAtIndex:indexPath.row];
    NSString *className = [[title componentsSeparatedByString:@"-"] lastObject];
    
    UIViewController* viewController = [[NSClassFromString(className) alloc] init];
    viewController.title = [[title componentsSeparatedByString:@"-"] firstObject];
    viewController.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
