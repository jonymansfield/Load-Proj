//
//  FRandomGenerator.h
//  KillThemALl
//
//  Created by fanyanfeng on 4/17/14.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRandomGenerator : NSObject

+ (NSInteger)randomIntegerFrom:(NSInteger)lower to:(NSInteger)upper;
+ (NSTimeInterval)randomTimeIntervalFrom:(NSTimeInterval)lower to:(NSTimeInterval)upper;

@end
