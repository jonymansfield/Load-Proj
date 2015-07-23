//
//  FViewController.m
//  KillThemALl
//
//  Created by fanyanfeng on 2015-04-14.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import "FMainVC.h"
#import "FMainScene.h"
#import "FGameOverVC.h"
#import "ScoreManager.h"
#import <AVFoundation/AVFoundation.h>

@interface FMainVC()

@property (nonatomic, retain)               IBOutlet    UIButton    *commentButton;
@property (nonatomic, retain)               IBOutlet    UIView      *menuView;
@property (nonatomic, retain)               IBOutlet    UIView      *gameOverView;
@property (nonatomic, retain)               IBOutlet    UILabel     *currentScoreLabel;
@property (nonatomic, retain)               IBOutlet    UILabel     *highScoreLabel;
@property (nonatomic, retain)               IBOutlet    UILabel     *currentModeLabel;
@property (nonatomic, getter = isPaused)                BOOL        paused;
@property (nonatomic, weak)                             FMainScene  *gameScene;

- (IBAction)pauseButtonAction:(id)sender;

@end

@implementation FMainVC {
    AVAudioPlayer *_backgroundMusicPlayer;
    AVAudioPlayer *_overMusicPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    self.menuView.hidden = NO;
    [self.view bringSubviewToFront:self.menuView];

    self.menuView.alpha = 1.0;
    self.gameOverView.alpha = 0.0;
    self.gameOverView.hidden = YES;
    
    SKView *skView = (SKView *)self.view;
    if (skView) {
        self.view.backgroundColor = [UIColor whiteColor];
        FMainScene *scene = [FMainScene sceneWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
        scene.backgroundColor = [SKColor whiteColor];
        scene.gameMode = self.gameMode;
        scene.scaleMode = SKSceneScaleModeAspectFit;
        scene.viewController = self;
        
        self.gameScene = scene;
        
        [skView presentScene:scene];
        
        scene.paused = YES;
        
    }

    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self playBackgroundMusic];
}

- (IBAction)normalMode:(id)sender {
    self.gameScene.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.gameScene.hidden = NO;
            self.menuView.hidden = YES;
            self.gameMode = SIGameModeNormal;
            SKView *skView = (SKView *)self.view;
            if (skView) {
                self.view.backgroundColor = [UIColor whiteColor];
                FMainScene *scene = [FMainScene sceneWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
                scene.backgroundColor = [SKColor whiteColor];
                scene.gameMode = self.gameMode;
                scene.scaleMode = SKSceneScaleModeAspectFit;
                scene.viewController = self;
                
                self.gameScene = scene;
                
                [skView presentScene:scene];
            }
        }
    }];
}

- (IBAction)middleMode:(id)sender {
    // TODO...
}

- (IBAction)hardMode:(id)sender {
    // TODO...
}

- (IBAction)pauseButtonAction:(id)sender {
    if(self.isPaused) {
        [self.gameScene resume];
    } else {
        [self.gameScene pause];
    }
    self.paused = !self.isPaused;
}

- (IBAction)playAgain:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.gameOverView.alpha = 0.0;
        self.menuView.alpha = 1.0;
        self.gameScene.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.gameOverView.hidden = YES;
            self.gameScene.hidden = NO;
            self.menuView.hidden = NO;
            [self playBackgroundMusic];
        }
    }];
}

- (void)gameOver {
    [self playGameOverMusic];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.gameOverView.alpha = 1.0;
        self.menuView.alpha = 0.0;
        self.gameScene.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.gameScene.hidden = YES;
            self.menuView.hidden = YES;
            self.gameOverView.hidden = NO;
            
            if (self.gameMode == SIGameModeNormal) {
                
                ScoreManager *scoreManager = [ScoreManager sharedManager];
                self.currentScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)scoreManager.mostRecentScore];
                self.highScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)scoreManager.highscore];
                self.currentModeLabel.text = @"普通难模式";
                
            } else if (self.gameMode == SIGameModeMiddle) {
                // TODO...
            } else {
                // TODO...
            }
        }
    }];
}

#pragma mark Music

- (void)playBackgroundMusic
{
    NSError *error;
    NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:@"Intro-Song.mp3" withExtension:nil];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    _backgroundMusicPlayer.numberOfLoops = -1;
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
}

- (void)stopBackgroundMusic {
    [_backgroundMusicPlayer stop];
}

- (void)playGameOverMusic {
    NSError *error;
    NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:@"Bomb-Lost.mp3" withExtension:nil];
    _overMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    _overMusicPlayer.numberOfLoops = 0;
    [_overMusicPlayer prepareToPlay];
    [_overMusicPlayer play];
}

#pragma mark UIApplication Notification

- (void)registerNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didEnterBackground:(NSNotification *)obj {
    if(!self.isPaused) {
        [self.gameScene pause];
        self.paused = YES;
    }
}

@end

