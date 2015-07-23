//
//  FMainScene.m
//  KillThemALl
//
//  Created by fanyanfeng on 2015-04-14.
//  Copyright (c) 2015 fan. All rights reserved.
//

#import "FMainScene.h"
#import "FSprite.h"
#import "FMainScene+collision.h"
#import "ScoreManager.h"
#import "FMainVC.h"

#define kRocketRange 1000.0
#define kVelocity 300.0
#define kMaxEscapedNumber 1

@interface FMainScene ()

@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic) FSprite *spaceship;
@property (nonatomic) SKTexture *monsterTexture;
@property (nonatomic) SKTexture *rocketTexture;
@property (nonatomic) NSTimeInterval timeUntilMonsterSpawn;
@property (nonatomic) NSTimeInterval timeLastUpdate;

@property(nonatomic,strong) SKAction *bombSound;


@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKLabelNode *escapedLabel;
@property (nonatomic) SKLabelNode *countDownLabel;
@property NSUInteger score;
@property NSUInteger escapedAndroids;
@property NSUInteger waitingTime;
@property NSTimeInterval startTime;
@property (getter = isGameStarted) BOOL gameStarted;

@property double currentAccelX;

@property (nonatomic, getter = isGamePaused) BOOL gamePaused;

@end

@implementation FMainScene {
    CGPoint _touchStartPoint;
    CGPoint _touchMovePoint;

    BOOL _isTouched;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _motionManager = [[CMMotionManager alloc] init];
        
        _spaceship = [[FSprite alloc] initWithImageNamed:@"Spaceship32.png"];
        _spaceship.texture.filteringMode = SKTextureFilteringNearest;

        _monsterTexture = [SKTexture textureWithImageNamed:@"Monster32.png"];
        _monsterTexture.filteringMode = SKTextureFilteringNearest;
        
        _rocketTexture = [SKTexture textureWithImageNamed:@"Rocket32.png"];
        _rocketTexture.filteringMode = SKTextureFilteringNearest;
        
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo"];
        
        _waitingTime = 3;
        _countDownLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo"];
        
        _gameStarted = NO;
        
        self.bombSound = [SKAction playSoundFileNamed:@"smallExplosion.caf" waitForCompletion:YES];

    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [self setupDisplay];
    [self configurePhysics];
    [self setupMotionManager];
    [self beginCountDown];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.isGameStarted && !self.isGamePaused) {
        self.startTime = currentTime;
        NSTimeInterval timeSinceLastUpdate = currentTime - self.timeLastUpdate;
        if(timeSinceLastUpdate > 1) {
            timeSinceLastUpdate = 1.0/60;
        }
        self.timeLastUpdate = currentTime;
        
        [self addAndroid:timeSinceLastUpdate];
    }
    
    [self movement];
    
}


-(void)setupDisplay {
    self.backgroundColor = [SKColor whiteColor];
    
    if (self.gameMode == SIGameModeNormal) {
        self.spaceship.position = CGPointMake(self.frame.size.width/2, self.spaceship.size.height);
        [self addChild:self.spaceship];
        
    } else if (self.gameMode == SIGameModeMiddle) {
        // TODO...
    } else {
        // TODO...
    }
    
    self.scoreLabel.fontSize = 15;
    self.scoreLabel.fontColor = [SKColor blackColor];
    self.scoreLabel.text = [NSString stringWithFormat:@"已抓数量: %d", 0];
    self.scoreLabel.position = CGPointMake(15 + self.scoreLabel.frame.size.width/2.0, self.size.height - (15 + self.scoreLabel.frame.size.height/2));
    
    self.countDownLabel.fontSize = 35;
    self.countDownLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)*0.75);
    self.countDownLabel.fontColor = [SKColor redColor];
    self.countDownLabel.name = @"countDown";
    self.countDownLabel.zPosition = 100;

    [self addChild:self.scoreLabel];
    [self addChild:self.countDownLabel];
}

-(void)setupMotionManager {
    self.motionManager.accelerometerUpdateInterval = 0.1;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
        if(!error) {
            [self processAccelerationData:accelerometerData.acceleration];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)beginCountDown {
    __weak FMainScene *weakSelf = self;
    SKAction *delay = [SKAction waitForDuration:1];
    SKAction *countdown = [SKAction runBlock:^{
        FMainScene *gameScene = weakSelf;
        gameScene.countDownLabel.text = [NSString stringWithFormat:@"%d", (int)gameScene.waitingTime];
        gameScene.waitingTime--;
    }];
    SKAction *countDownSequence = [SKAction sequence:@[countdown, delay]];
    SKAction *repeat = [SKAction repeatAction:countDownSequence count:self.waitingTime];
    
    SKAction *complete = [SKAction runBlock:^{
        FMainScene *gameScene = weakSelf;
        gameScene.gameStarted = YES;
        gameScene.countDownLabel.hidden = YES;
    }];
    [self.countDownLabel runAction:[SKAction sequence:@[repeat, complete]]];
}

-(void)processAccelerationData:(CMAcceleration)acceleration {
    self.currentAccelX = acceleration.x;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self runAction:self.bombSound completion:^{
        
    }];

    if (self.gameMode == SIGameModeNormal) {
    
        SKSpriteNode *rocket = [SKSpriteNode spriteNodeWithTexture:self.rocketTexture];
        rocket.position = CGPointMake(self.spaceship.position.x, self.spaceship.position.y + self.spaceship.size.height);
        
        [self addChild:rocket];
        
        CGFloat moveDuration = self.size.width / kVelocity;
        
        CGPoint rocketDest = CGPointMake(rocket.position.x, kRocketRange);
        
        SKAction *actionMove = [SKAction moveTo:rocketDest duration:moveDuration];
        SKAction *actionMoveDone = [SKAction removeFromParent];
        [rocket runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
        
        [FMainScene prepareCollisionForRocket:rocket];
        
        
    } else if (self.gameMode == SIGameModeMiddle) {
        // TODO...
    } else {
        // TODO...
    }
}

- (void)addAndroid:(NSTimeInterval)timeSinceLastUpdate {
    self.timeUntilMonsterSpawn -= timeSinceLastUpdate;
    if(self.timeUntilMonsterSpawn > 0) {
        return;
    }
    
    if (self.gameMode == SIGameModeNormal) {
        
        self.timeUntilMonsterSpawn += [FRandomGenerator randomTimeIntervalFrom:0.1 to:0.15];
        
    } else if (self.gameMode == SIGameModeMiddle) {
        // TODO...
    } else {
        // TODO...
    }

    
    SKSpriteNode *android = [SKSpriteNode spriteNodeWithTexture:self.monsterTexture];
    
    NSInteger androidWidth = android.size.width;
    NSInteger androidHeight = android.size.height;
    
    NSInteger minX = androidWidth;
    NSInteger maxX = self.frame.size.width - androidWidth;
    NSInteger actualX = [FRandomGenerator randomIntegerFrom:minX to:maxX];
    
    android.position = CGPointMake(actualX, self.frame.size.height);
    [self addChild:android];
    
    NSTimeInterval duration = [FRandomGenerator randomTimeIntervalFrom:1.0 to:1.5];
    
    if (self.gameMode == SIGameModeNormal) {

        duration = [FRandomGenerator randomTimeIntervalFrom:1.0 to:1.5];
        
    } else if (self.gameMode == SIGameModeMiddle) {
        // TODO...
    } else {
        // TODO...
    }
    
    __weak FMainScene *weakSelf = self;
    SKAction *actionMove = [SKAction moveTo:CGPointMake(actualX, -androidHeight) duration:duration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    SKAction *actionAddToEscapedScore = [SKAction runBlock:^{
        FMainScene *gameScene = weakSelf;
        [gameScene addToEscaped:1];
    }];
    [android runAction:[SKAction sequence:@[actionMove, actionAddToEscapedScore, actionMoveDone]]];
    
    [FMainScene prepareCollisionForMonster:android];
}

-(void)addToScore:(NSUInteger)points {
    self.score += points;
    self.scoreLabel.text = [NSString stringWithFormat: @"已抓数量: %d", (int)self.score];
}

-(void)addToEscaped:(NSUInteger)badpoints {
    self.escapedAndroids += badpoints;
    if(self.escapedAndroids >= kMaxEscapedNumber) {
        self.paused = true;
        self.gamePaused = true;
        [self performSelector:@selector(gameOver) withObject:nil afterDelay:0.3];
    }
}

- (void)pause {
    self.paused = true;
    self.gamePaused = true;
}

- (void)resume {
    self.paused = false;
    self.gamePaused = false;
}

- (void)showOverView {
    
}

-(void)gameOver {
    self.gameStarted = NO;
    self.paused = YES;
    [self.motionManager stopAccelerometerUpdates];
    if (self.gameMode == SIGameModeNormal) {
        
        ScoreManager *scoreManager = [ScoreManager sharedManager];
        [scoreManager addScoreToLeaderboard:self.score];
    } else if (self.gameMode == SIGameModeMiddle) {
        // TODO...
    } else {
        // TODO...
    }
    
    [self.viewController gameOver];
}

-(void)movement {
    
    if (self.gameMode == SIGameModeNormal) {
        
        float maxX = self.frame.size.width - self.spaceship.size.width/2-60;
        float minX = self.spaceship.size.width/2+60;
        
        float newX = self.currentAccelX*20;
        newX = MIN(MAX(newX + self.spaceship.position.x, minX), maxX);
        self.spaceship.position = CGPointMake(newX, self.spaceship.position.y);

    } else if (self.gameMode == SIGameModeMiddle) {
        // TODO...
    } else {
        // TODO...
    }

}

@end
