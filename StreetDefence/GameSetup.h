//
//  GameSetup.h
//  StreetDefence
//
//  Created by Freddie on 08/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameController.h"

#import "LevelSetupCharacterPanel.h"
#import "LevelMapPlanning.h"
#import "TeamSelect.h"

@interface GameSetup : UIViewController {
    LevelSetupCharacterPanel *charSetup;
    LevelMapPlanning *lmp;
    TeamSelect *teamSelect;
    UIButton *startButton, *team;
    UIView *cover;
}

@property (nonatomic) int level;

- (void) StartGame;
- (void) SelectTeam;
- (void) UpdateTeam:(NSMutableArray*)_newTeam;
- (void) CharacterMoved:(NSArray*)_newLocal;

@end
