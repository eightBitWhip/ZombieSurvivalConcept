//
//  Kid.h
//  StreetDefence
//
//  Created by Freddie on 09/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KidAudioManager.h"

@interface Kid : UIView {
    int accuracy, hp, maxhp;
    UIView *active;
    KidAudioManager *kam;
}

@property (nonatomic) CGPoint destination, start, wayPoint;
@property (nonatomic) int state, room, wayRoom, destRoom, ammo, kills, upPoints;
@property (nonatomic) NSObject *parent;
@property (nonatomic) float triggerSpeed, reloadSpeed, speed;
@property (nonatomic) NSString *name;
@property (nonatomic) UILabel *ammoLabel;
@property (nonatomic) bool closeQuarters, longRange, extraAmmo;

- (id) initData:(NSMutableDictionary*)_profile Start:(CGPoint)_startPos;

- (void) Move;
- (void) Shoot;
- (void) DoneShooting;
- (void) Reload;
- (void) Die;
- (void) Select;
- (void) Deselect;
- (void) StartedMove;
- (void) Countered;

@end
