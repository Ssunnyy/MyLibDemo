//
//  MBXPageViewController.h
//  MBXPageViewController v0.5
//
//  Created by Nico Arqueros on 10/17/14.
//  Copyright (c) 2014 Moblox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MBXPageMode) {
    MBX_FreeButtons,
    MBX_LeftRightArrows,
    MBX_SegmentController
};

@protocol MBXPageControllerDataSource;
@protocol MBXPageControllerDataDelegate;

@interface MBXPageViewController : UIPageViewController

@property (nonatomic, assign) id<MBXPageControllerDataSource>   MBXDataSource;
@property (nonatomic, assign) id<MBXPageControllerDataDelegate> MBXDataDelegate;

@property (nonatomic, assign) MBXPageMode                           pageMode;     // This selects the mode of the PageViewController

- (void)reloadPages;                                                        // Like reloadData in tableView. You need to call this method to update the stack of viewcontrollers and/or buttons
- (void)reloadPagesToCurrentPageIndex:(NSInteger)currentPageIndex;          // Like reloadData in tableView. You need to call this method to update the stack of viewcontrollers and/or buttons

- (void)moveToViewNumber:(NSInteger)viewNumber __attribute__((deprecated));                // Default to YES. Deprecated.
- (void)moveToViewNumber:(NSInteger)viewNumber animated:(BOOL)animated;     // The ViewController position. Starts from 0
@end

@protocol MBXPageControllerDataSource <NSObject>
@required
- (NSArray *)MBXPageButtons;
- (NSArray *)MBXPageControllers;
- (UIView *)MBXPageContainer;
@optional
- (void)otherConfiguration;                         // Good place to put methods that you want to execute after everything is ready i.e. moveToViewNumber to set a different starting page.
@end

@protocol MBXPageControllerDataDelegate <NSObject>
@optional
- (void)MBXPageChangedToIndex:(NSInteger)index;
@end
