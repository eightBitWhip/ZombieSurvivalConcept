//
//  LevelCompletePanel.h
//  StreetDefence
//
//  Created by Freddie on 22/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelCompletePanel : UIView {
    NSObject *parent;
    NSMutableArray *kids, *upgrades1, *upgrades2, *upgrades3;
    int currentKid, zombieCount;
    UIButton *speedB, *triggerB, *reloadB, *close, *range, *ammo, *undoButton;
    UIView *upgradesPanel;
    UIImageView *highlight;
}

- (id) initWithFrame:(CGRect)frame Parent:(NSObject*)_parent Kids:(NSMutableArray*)_kids Score:(int)_score Zombies:(int)_zombieCount;

- (void) KidSelected:(UITapGestureRecognizer*)_sender;
- (void) PerkStatSelected:(UITapGestureRecognizer*)_sender;
- (void) Undo;
- (void) Done;
- (void) ShowUpgradePanel;
- (void) ShowUndoButton;

- (float) CheckPoints:(NSString*)_type;

- (int) CanAfford;

- (UIButton*) CreatePerkButton:(NSString*)_type Frame:(CGRect)_rect;

- (UILabel*) CreateButtonLabel:(CGRect)_frame Color:(UIColor*)_color Text:(NSString*)_text;

- (BOOL) HasPerkBeenSelected:(NSString*)_perk;

- (NSMutableArray*) AddNewPerksForSave:(NSMutableArray*)_skills;

@end
