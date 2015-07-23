//
//  ScoreManager.h
//  KillThemALl
//
//  Created by fanyanfeng on 2015-05-07.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreManager : NSObject

@property (nonatomic, readonly) NSUInteger mostRecentScore;
@property (nonatomic, readonly) NSUInteger highscore;
@property (nonatomic, readonly) NSArray *leaderboard;

+ (instancetype)sharedManager;
- (void)addScoreToLeaderboard:(NSUInteger)score;

@end
