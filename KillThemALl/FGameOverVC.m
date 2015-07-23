//
//  FGameOverVC.m
//  KillThemALl
//
//  Created by fanyanfeng on 2015-05-07.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import "FGameOverVC.h"
#import "ScoreManager.h"

@interface FGameOverVC()
@property (nonatomic, retain) IBOutlet UILabel *currentScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *highScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentModeLabel;

@end

@implementation FGameOverVC

- (IBAction)playAgainAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToMenuAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
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


-(BOOL)shouldAlertQAView:(UIAlertView *)alertView{
    return NO;
}

@end
