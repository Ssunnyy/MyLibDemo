//
//  NSArray+YU.h
//  YUKit<https://github.com/c6357/YUKit>
//
//  Created by BruceYu on 15/9/2.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YU)


-(id)objAtIndex:(NSUInteger)index;

-(NSMutableArray*)arrayWithKey:(NSString*)key;

-(NSMutableDictionary*)dictionaryWithKey:(NSString*)key;

-(NSMutableDictionary*)dictionaryWithIntKey:(NSString*)key;

+(id)arrayWithCArray:(char**)strs len:(NSInteger)length;

@end
