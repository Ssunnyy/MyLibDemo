//
//  ViewController.m
//  ActionSheetPickerView
//  Copyright (c) 2013 Iftekhar. All rights reserved.


#import "IQActionSheetDemo.h"
#import "IQActionSheetPickerView.h"


@interface IQActionSheetDemo ()<IQActionSheetPickerViewDelegate>

@end

@implementation IQActionSheetDemo

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    switch (pickerView.tag)
    {
        case 1: [buttonSingle setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 2: [buttonDouble setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 3: [buttonTriple setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 4: [buttonRange setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 5: [buttonTripleSize setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        case 6: [buttonDate setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
            
        default:
            break;
    }
}

- (IBAction)onePickerViewClicked:(UIButton *)sender
{
     IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Single Picker" delegate:self];
    [picker setTag:1];
    [picker setTitlesForComponents:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"First", @"Second", @"Third", @"Four", @"Five", nil],
                                     nil]];
    [picker show];

}

- (IBAction)twoPickerViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Double Picker" delegate:self];
    [picker setTag:2];
    [picker setTitlesForComponents:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"First 1", @"Second 1", @"Third 1", @"Four 1", @"Five 1", nil],
                                     [NSArray arrayWithObjects:@"First 2", @"Second 2", @"Third 2", @"Four 2", @"Five 2", nil],
                                     nil]];
    [picker show];
}

- (IBAction)threePickerViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Three Picker" delegate:self];
    [picker setTag:3];
    [picker setTitlesForComponents:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"First 1", @"Second 1", @"Third 1", @"Four 1", @"Five 1", nil],
                                     [NSArray arrayWithObjects:@"First 2", @"Second 2", @"Third 2", @"Four 2", @"Five 2", nil],
                                     [NSArray arrayWithObjects:@"First 3", @"Second 3", @"Third 3", @"Four 3", @"Five 3", nil],
                                     nil]];
    [picker show];
}

- (IBAction)rangeSelectClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Range Selector" delegate:self];
    [picker setTag:4];
    [picker setIsRangePickerView:YES];
    [picker setTitlesForComponents:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"100", @"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900", nil],
                                     [NSArray arrayWithObjects:@"To", nil],
                                     [NSArray arrayWithObjects:@"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900",@"1000", nil],
                                     nil]];
    
    [picker setTitlesForComponents:@[]];
    [picker show];
}

- (IBAction)threePickerViewWithWidths:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Range Selector With Size" delegate:self];
    [picker setTag:5];
    [picker setIsRangePickerView:YES];
    [picker setTitlesForComponents:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"100", @"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900", nil],
                                     [NSArray arrayWithObjects:@"To", nil],
                                     [NSArray arrayWithObjects:@"200", @"300", @"400", @"500",@"600", @"700", @"800", @"900",@"1000", nil],
                                     nil]];
    [picker setWidthsForComponents:[NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:120],
                                    [NSNumber numberWithFloat:60],
                                    [NSNumber numberWithFloat:120],
                                    nil]];
    [picker show];
}

- (IBAction)datePickerViewClicked:(UIButton *)sender
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date Picker" delegate:self];
    [picker setTag:6];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
