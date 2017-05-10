//
//  CocoaPickerViewController.m
//  CocoaPicker
//
//  Created by Cocoa Lee on 15/8/25.
//  Copyright (c) 2015年 Cocoa Lee. All rights reserved.
//

#import "CocoaPickerViewController.h"
#import "CocoaHederView.h"
#import "CocoaImageViewController.h"
#import "CocoaAlbumViewController.h"
@interface CocoaPickerViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong,readonly) NSArray *nameArray;
@property(nonatomic,strong,readonly) NSArray *imageArray;
@property(nonatomic,strong)           CocoaHederView *hederView;
@property(nonatomic,assign)          BOOL isChosePhotoFromHeaderScrollView;
@property(nonatomic,strong)          UILabel *label;
@property (strong,nonatomic)UITableView *tableView;

@end

@implementation CocoaPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)initView {
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor orangeColor];
    topView.frame = CGRectMake(0, 0,CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 340);
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor clearColor];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [topView addGestureRecognizer:tap];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.bounds.size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topView.bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    _hederView = [[CocoaHederView alloc] init];
    
    
    _nameArray = @[@"拍照",@"相册",@"取消"];
    
    _isChosePhotoFromHeaderScrollView = NO;
    
}


#pragma mark -delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    line.frame = CGRectMake(0, 0, tableView.bounds.size.width, 1);
    [cell addSubview:line];
    
    cell.textLabel.text = _nameArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.row == 0) {
        _label = cell.textLabel;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    __weak typeof (&*self)weakSelf = self;
    
    __block UILabel *label =  _label;
    _hederView.sendImageBlock = ^(NSArray *imageArray){
//        改变row 0 的标题和作用
        
        if (imageArray.count == 0) {
            _isChosePhotoFromHeaderScrollView = NO;
            label.text = @"拍照";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:17];
        }
        else{
            _isChosePhotoFromHeaderScrollView = YES;
            label.text = [NSString stringWithFormat:@"发送 %lu 张",(unsigned long)imageArray.count];
            label.textColor = [UIColor colorWithRed:255/255.0 green:28/255.0 blue:109/255.0 alpha:1];
            label.font = [UIFont systemFontOfSize:20];
            _imageArray = imageArray;
        }
       
    };
    return _hederView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == 0) {
        
        if (_isChosePhotoFromHeaderScrollView) {
            if ([self.delegate respondsToSelector:@selector(CocoaPickerViewSendBackWithImage:andString:)]) {
                [self.delegate CocoaPickerViewSendBackWithImage:_imageArray andString:@"选择的照片"];
            }
            [self dismiss];
            
        }
        else {
            [self tackPhotoOrChoseFromLib:indexPath.row];
        }
    }
    else if (indexPath.row == 1){
        [self tackPhotoOrChoseFromLib:indexPath.row];
    }
    else if (indexPath.row == 2){
        [self dismiss];
    }
}


#pragma mark -dataSouce
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 190;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 50;
}


#pragma mark dismiss
- (void)dismiss{
    NSLog(@"dismiss");
  __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
   
}

#pragma mark -启动相机或者相册
- (void)tackPhotoOrChoseFromLib : (NSInteger )indexPathRow{
    
    
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if (indexPathRow == 0) {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self alertWithTitle:@"提示" andMessage:@"相机启动失败" andButtonTitle:@"确定" andButtonTitle:@"取消"];
            return;
        }
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else if (indexPathRow == 1) {
//        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//            [self alertWithTitle:@"提示" andMessage:@"访问相册失败" andButtonTitle:@"确定" andButtonTitle:@"取消"];
//            return;
//        }
//        
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        CocoaAlbumViewController *picker=[[CocoaAlbumViewController alloc]init];
        picker.newimageArray=_hederView.newimageArray;
        picker.sendBackArray=_hederView.sendBackArray;
        picker.albumArray=_hederView.albumArray;
        picker.selectBlock=^(BOOL isyes){
            if (isyes) {
                [self.delegate CocoaPickerViewSendBackWithImage:_hederView.sendBackArray andString:@"选择的照片"];
            }
            [self dismiss];
        };
        MyNavigationController *nav=[[MyNavigationController alloc]initWithRootViewController:picker];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
 
    
}




#pragma mark -pickerViewDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    传到 首页
    NSLog(@"%@",info);
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSMutableDictionary *pare=[NSMutableDictionary dictionary];
    [pare setValue:image forKey:@"image"];
    
    if ([self.delegate respondsToSelector:@selector(CocoaPickerViewSendBackWithImage:andString:)]) {
        [self.delegate CocoaPickerViewSendBackWithImage:[NSArray arrayWithObject:image] andString:@"选择的照片"];
    }
    __weak typeof (&*self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf dismiss];
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismiss];
}



-(UIAlertView *)alertWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitle:(NSString *)titleOne andButtonTitle:(NSString *)titleTwo{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:titleOne otherButtonTitles:titleTwo, nil];
    [alert show];
    return alert;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
