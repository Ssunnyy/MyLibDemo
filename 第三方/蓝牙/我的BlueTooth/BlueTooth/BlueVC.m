//
//  BlueVC.m
//  BlueTooth
//
//  Created by hai on 16/4/27.
//  Copyright © 2016年 soft－angel. All rights reserved.
//

#import "BlueVC.h"
#import "BlueToothManager.h"

@interface BlueVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UITableView *_tableView1;
    NSMutableArray *_dataSourceList;
    
    BlueToothManager *_manager;
    
    UILabel *_label;
}

@end

@implementation BlueVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _manager = [BlueToothManager getInstance];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSourceList = [[NSMutableArray alloc] init];
    [_dataSourceList addObject:@"0A10CB30-0000-0000-00CB-075582842602"];
    [_dataSourceList addObject:@"0A10CB32-0000-0000-00CB-075582842602"];
    [_dataSourceList addObject:@"0A10CB31-0000-0000-00CB-075582842602"];
//    [_dataSourceList addObject:@"BTA2"];
//    [_dataSourceList addObject:@"BTA40"];
//    [_dataSourceList addObject:@"BTA50"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didCLickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-110, 0, 100, 60)];
    [button1 setTitle:@"扫描服务" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(CLickButton1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 100) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100) style:UITableViewStyleGrouped];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    [self.view addSubview:_tableView1];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 330, self.view.frame.size.width, self.view.frame.size.height-330)];

    _label.text = @"什么鬼";
    _label.numberOfLines = 0;
    [self.view addSubview:_label];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return [_manager servicesInfo].count;
    } else {
        return [_manager characteristicsInfo].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        if ([_manager servicesInfo].count>0) {
            CBService *ser = [_manager servicesInfo][indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",ser.UUID];
        }
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        if ([_manager servicesInfo].count>0) {
            CBCharacteristic *cha = [_manager characteristicsInfo][indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",cha.UUID];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if ([_manager servicesInfo].count>0) {
            CBService *ser = [_manager servicesInfo][indexPath.row];
            [_manager starSaomiaoTezheng:ser];
        }
            [_tableView1 reloadData];
    } else {
        if ([_manager characteristicsInfo].count>0) {
            CBCharacteristic *cha = [_manager characteristicsInfo][indexPath.row];
            [_manager starSaomiaoTezhengxinxi:cha];
            NSString * str = [NSString stringWithFormat:@"%@",cha.UUID];
            [_manager sendDataWithString:str];
            [_manager showResult];
        }
    }
    
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:0];
    [mutableStr appendString:@"\r 所有的特征UUID为 \n \n \n"];
    for (CBCharacteristic *chara in [_manager characteristicsInfo]) {
        NSString * str = [NSString stringWithFormat:@"%@",chara.UUID];
        [mutableStr appendString:str];
        [mutableStr appendString:@"\n"];
    }
    _label.text = mutableStr;
//
    /*
     NSMutableString *mutableStr = [NSMutableString stringWithCapacity:0];
     [mutableStr appendString:@"\r 所有的特征UUID为 \n \n \n"];
     for (CBCharacteristic *chara in [_manager characteristicsInfo]) {
     NSString * str = [NSString stringWithFormat:@"%@",chara.UUID];
     [mutableStr appendString:str];
     [mutableStr appendString:@"\n"];
     }
     _label.text = mutableStr;
    */
//    [_manager showResult];
}

- (void)didCLickButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)CLickButton1{
    [_tableView reloadData];
}
@end
