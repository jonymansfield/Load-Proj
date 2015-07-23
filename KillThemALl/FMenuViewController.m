//
//  FMenuViewController.m
//  KillThemALl
//
//  Created by fan yanfeng on 14-5-25.
//  Copyright (c) 2015年 fan. All rights reserved.
//

#import "FMenuViewController.h"
#import "FMainVC.h"


@interface FMenuViewController ()

@property (nonatomic,assign) SIGameMode gameMode;

@end

@implementation FMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)normalMode:(id)sender {
    self.gameMode = SIGameModeNormal;
}

- (IBAction)middleMode:(id)sender {
    self.gameMode = SIGameModeMiddle;
}

- (IBAction)hardMode:(id)sender {
    self.gameMode = SIGameModeHard;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FMainVC *vc = (FMainVC *)[segue destinationViewController];
    vc.gameMode = self.gameMode;
}

@end
