//
//  LevelSetupCharacterPanel.h
//  StreetDefence
//
//  Created by Freddie on 08/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CharacterIcon.h"

#import "Kid.h"

@interface LevelSetupCharacterPanel : UIView {
    UIView *selected;
    CharacterIcon *face1, *face2, *face3;
    NSMutableArray *charactersArr;
}

@property (nonatomic) bool charSelected; // init with characters from data etc.
@property (nonatomic) CharacterIcon *current;

- (id) initWithFrame:(CGRect)frame Tags:(NSMutableArray*)_tags;
- (id) initWithFrame:(CGRect)frame Kids:(NSMutableArray*)_kids;

- (void) CharSelected:(UITapGestureRecognizer*)_sender;
- (void) KidDied:(Kid*)_kid;
- (void) KidReloadToggle:(Kid*)_kid;
- (void) initCharData;
- (void) AddLabelToPic:(NSString*)_name Loc:(CGPoint)_loc;

- (NSMutableArray*) GetKidsForGame;
- (NSMutableArray*) GetKidsForLevelComplete;

- (UILabel*) CreateAmmoLabel:(CGRect)_frame;

- (BOOL) CanSelectTeam;
- (BOOL) CanStartGame;

@end
