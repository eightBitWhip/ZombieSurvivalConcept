//
//  GameController.h
//  StreetDefence
//
//  Created by Freddie on 08/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "LevelSetupCharacterPanel.h"
#import "GameOver.h"
#import "LevelCompletePanel.h"

#import "Zombie.h"

#import "PathFindingUt.h"

@interface GameController : UIViewController {
    NSMutableArray *zombies, *rooms, *zomStarts;
    NSArray *zombieTypes;
    NSTimer *gameTimer, *zombieAddTimer;
    UIView *mapScreen, *eventMessage;
    LevelSetupCharacterPanel *characterPanel;
    PathFindingUt *pfut;
    int score, zombieCount;
}

@property (nonatomic) NSMutableArray *kids;
@property (nonatomic, strong) AVAudioPlayer *aVPlayer;
@property (nonatomic) int level;

- (void) GameLoop;

- (void) CheckCollisions;
- (void) MoveZombies;
- (void) AddZombie;
- (void) LevelComplete;
- (void) GameOver;
- (void) Retry;
- (void) Pause;
- (void) SetKidsRooms;
- (void) KidSetNewWay:(Kid*)_kid;
- (void) ZomSetNewWay:(Zombie*)_zombie;
- (void) ZomSetNewDest:(Zombie*)_zombie;
- (void) LevelFinishedPointsDone;
- (void) ShowEventMessage:(int)_type;
- (void) AddSpit:(CGPoint)_local;

@end
