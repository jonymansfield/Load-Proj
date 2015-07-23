//
//  ScoreManager.m
//  KillThemALl
//
//  Created by fanyanfeng on 2015-05-07.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import "ScoreManager.h"

#define kScoreFilename @"scores.dat"
#define kMaximumNumberOfScores 5

@interface ScoreManager()

@property (nonatomic) NSUInteger mostRecentScore;
@property (nonatomic) NSMutableArray *scores;
@property (nonatomic) BOOL dirty;

@end

@implementation ScoreManager

+ (instancetype)sharedManager {
    static ScoreManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ScoreManager alloc] initPrivate];
    });
    return sharedManager;
}

- (id)init {
    NSAssert(NO, @"Call into the singleton!");
    return nil;
}

- (instancetype)initPrivate {
    if(self = [super init]) {
        _scores = [ScoreManager loadScoreFromFile];
    }
    return self;
}

+ (NSMutableArray *)loadScoreFromFile {
    NSString *path = [ScoreManager pathForFile];
    NSMutableArray *scores = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] mutableCopy];
    return scores ? scores : [NSMutableArray array];
}

+ (NSString *)pathForFile {
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *path = [url.path stringByAppendingPathComponent:kScoreFilename];
    return path;
}

- (NSUInteger)highscore {
    return [[self.scores firstObject] unsignedIntegerValue];
}

- (NSArray *)leaderboard {
    return self.scores;
}

- (void)addScoreToLeaderboard:(NSUInteger)score {
    [self insertScore:score intoSortedArray:self.scores];
    self.mostRecentScore = score;
    
    if(self.dirty) {
        NSString *path = [ScoreManager pathForFile];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.scores];
        [data writeToFile:path atomically:YES];
        self.dirty = NO;
    }
}

- (void)insertScore:(NSUInteger)score intoSortedArray:(NSMutableArray *)array {
    NSUInteger indexToInsert = [array count];
    for(int i = 0; i < [array count]; i++) {
        if(score <= [array[i] unsignedIntegerValue]) {
            continue;
        }
        indexToInsert = i;
        break;
    }
    
    if(indexToInsert >= kMaximumNumberOfScores) {
        return;
    }
    
    [array insertObject:[NSNumber numberWithUnsignedInteger:score] atIndex:indexToInsert];
    if([array count] >= kMaximumNumberOfScores) {
        [array removeLastObject];
    }
    self.dirty = YES;
}

@end
