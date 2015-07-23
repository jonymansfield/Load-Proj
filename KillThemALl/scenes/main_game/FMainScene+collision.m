//
//  FMainScene+collision.m
//  KillThemALl
//
//  Created by fanyanfeng on 4/18/14.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import "FMainScene+collision.h"

NS_ENUM(u_int32_t, CollisionCategory) {
    CollisionMonsterCategory,
    CollisionRocketCategory
};

@interface FMainScene() <SKPhysicsContactDelegate>


@end

@implementation FMainScene (collision)

- (void)configurePhysics {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
}

+ (void)prepareCollisionForMonster:(SKSpriteNode *)monster {
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size];
    monster.physicsBody.dynamic = YES;// 是否是静态
    monster.physicsBody.categoryBitMask = CollisionMonsterCategory;
    monster.physicsBody.contactTestBitMask = CollisionRocketCategory;
    monster.physicsBody.collisionBitMask = 0;
    monster.physicsBody.usesPreciseCollisionDetection = YES;//启用精确冲突检测
}

+ (void)prepareCollisionForRocket:(SKSpriteNode *)rocket {
    rocket.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rocket.size];
    rocket.physicsBody.dynamic = YES;
    rocket.physicsBody.categoryBitMask = CollisionRocketCategory;
    rocket.physicsBody.contactTestBitMask = CollisionMonsterCategory;
    rocket.physicsBody.collisionBitMask = 0;
    rocket.physicsBody.usesPreciseCollisionDetection = YES;
}

#pragma mark SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *bodyA = contact.bodyA;
    SKPhysicsBody *bodyB = contact.bodyB;
    
    if(bodyA.categoryBitMask == bodyB.contactTestBitMask && bodyB.categoryBitMask == bodyA.contactTestBitMask) {
//        NSLog(@"Collision!");
        if(bodyA.categoryBitMask == CollisionMonsterCategory) {
            [bodyA.node fadeOutWithDuration:0.1];
            [bodyB.node removeFromParent];
            
        } else {
            [bodyA.node removeFromParent];
            [bodyB.node fadeOutWithDuration:0.1];
        }
        
        [self addToScore:1];
    }
}

@end
