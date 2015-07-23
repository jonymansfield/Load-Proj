//
//  SKNode+collision_animation.m
//  KillThemALl
//
//  Created by fanyanfeng on 2015-04-30.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import "SKNode+collision_animation.h"

@implementation SKNode (collision_animation)

- (void)fadeOutWithDuration:(NSTimeInterval)sec {
    SKAction *fadeAway      = [SKAction fadeOutWithDuration:sec];
    SKAction *removeNode    = [SKAction removeFromParent];
    SKAction *sequence      = [SKAction sequence:@[fadeAway, removeNode]];
    
    [self runAction:sequence];
}

@end
