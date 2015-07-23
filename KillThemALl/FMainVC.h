//
//  FViewController.h
//  KillThemALl
//
//  Created by fanyanfeng on 2015-04-14.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "FMainScene.h"

@interface FMainVC : UIViewController

@property (nonatomic, assign) SIGameMode gameMode;

- (void)gameOver;

@end
