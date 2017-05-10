//
//  ViewController.m
//  BlueToothTest
//
//  Created by soft-angel on 15/12/25.
//  Copyright © 2015年 soft－angel. All rights reserved.
//

#import "ViewController.h"
#import "BlueToothManager.h"
#import "BlueVC.h"

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray * _peripheralList;
    UITableView * _tableView;
    BlueToothManager * _manager;
    
    NSTimer *_timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//     _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    _peripheralList = [[NSMutableArray alloc]initWithCapacity:0];
    [self createTableView];
    _manager = [BlueToothManager getInstance];
    
}


-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_tableView];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 100, 100)];
    [btn setTitle:@"扫描" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)btnClick
{
    [_manager startScan];
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getNameList) userInfo:nil repeats:YES];
    
}

-(void)getNameList
{
    _peripheralList = [_manager getNameList];
    NSLog(@"=====%@",_peripheralList);
    [_tableView reloadData];
    
}

-(void)btn1Click
{
    [_manager openNotify];
//    NSString * str = @"BTA0";//@"p1555515757600000000";
//    [_manager sendDataWithString:str];
//    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(openLock) userInfo:nil repeats:NO];
    
}

-(void)openLock
{
    NSString * str = @"BTA0";
    [_manager sendDataWithString:str];
    [_manager showResult];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _peripheralList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    CBPeripheral * per = _peripheralList[indexPath.row];
    cell.textLabel.text = per.name;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral * per = _peripheralList[indexPath.row];
    [_manager connectPeripheralWith:per];
    
    BlueVC *vc = [[BlueVC alloc] init];
    [self presentViewController:vc animated:YES completion:NULL];
    
    [_timer invalidate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
