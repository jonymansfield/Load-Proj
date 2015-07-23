//
//  FMainScene.h
//  KillThemALl
//
//  Created by fanyanfeng on 2015-04-14.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@class FMainVC;

@interface FMainScene : SKScene

@property (nonatomic, weak) FMainVC *viewController;
@property (nonatomic, readonly, getter = isGameStarted) BOOL gameStarted;
@property (nonatomic, assign) SIGameMode gameMode;

- (void)addToScore:(NSUInteger)points;
- (void)pause;
- (void)resume;

@end
