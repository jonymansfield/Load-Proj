//
//  FMainScene+collision.h
//  KillThemALl
//
//  Created by fanyanfeng on 4/18/14.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import "FMainScene.h"

@interface FMainScene (collision)

- (void)configurePhysics;
+ (void)prepareCollisionForMonster:(SKSpriteNode *)monster;
+ (void)prepareCollisionForRocket:(SKSpriteNode *)rocket;

@end
