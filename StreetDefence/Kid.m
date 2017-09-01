//
//  Kid.m
//  StreetDefence
//
//  Created by Freddie on 09/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "Kid.h"

@implementation Kid {
    int ammoCap;
}

@synthesize destination, state, parent, start, triggerSpeed, name, ammo, room, wayPoint, wayRoom, destRoom, ammoLabel, closeQuarters, longRange, extraAmmo, kills, reloadSpeed, speed, upPoints;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initData:(NSMutableDictionary *)_profile Start:(CGPoint)_startPos {
    if ( self = [super initWithFrame:CGRectMake(_startPos.x, _startPos.y, 6, 6)] ) {
        kam = [[KidAudioManager alloc] init];
        triggerSpeed = [[_profile objectForKey:@"triggerSpeed"] floatValue];
        reloadSpeed = [[_profile objectForKey:@"reloadSpeed"] floatValue];
        name = [_profile objectForKey:@"name"];
        ammo = 15;
        
        for ( NSString *skill in [_profile objectForKey:@"skills"] ) {
            if ( [skill isEqualToString:@"close"] ) { closeQuarters = YES; }
            else if ( [skill isEqualToString:@"range"] ) { longRange = YES; }
            else if ( [skill isEqualToString:@"ammo"] ) { extraAmmo = YES; ammo = 25; }
        }
        
        if ( [_profile objectForKey:@"upPoints"] ) {
            upPoints = [[_profile objectForKey:@"upPoints"] intValue];
        }
        else { upPoints = 0; }
        
        ammoCap = ammo;
        
        state = 0; kills = 0;
        start = _startPos;
        speed = [[_profile objectForKey:@"speed"] floatValue];
        self.backgroundColor = [UIColor clearColor];
        UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        dot.image = [UIImage imageNamed:@"kidDot.png"];
        [self addSubview:dot];
        active = [[UIView alloc] initWithFrame:CGRectMake(-3, -3, 12, 12)];
        active.backgroundColor = [UIColor clearColor];
        active.hidden = YES; [self addSubview:active];
        UIImageView *hi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        hi.image = [UIImage imageNamed:@"kidPicked.png"];
        [active addSubview:hi];
    }
    return self;
}

- (void) Move {
    if ( state != 3 ) {
        float newX, newY;
        if ( wayPoint.x > self.center.x ) {
            if ( wayPoint.x - self.center.x < speed ) {
                newX = wayPoint.x;
            }
            else { newX = self.center.x + speed; }
        }
        else {
            if ( self.center.x - wayPoint.x < speed ) {
                newX = wayPoint.x;
            }
            else { newX = self.center.x - speed; }
        }
        if ( wayPoint.y > self.center.y ) {
            if ( wayPoint.y - self.center.y < speed ) {
                newY = wayPoint.y;
            }
            else { newY = self.center.y + speed; }
        }
        else {
            if ( self.center.y - wayPoint.y < speed ) {
                newY = wayPoint.y;
            }
            else { newY = self.center.y - speed; }
        }
        self.center = CGPointMake(newX, newY);
        
        if ( self.center.x == destination.x && self.center.y == destination.y ) {
            state = 0;
            self.room = self.destRoom;
        }
    }
}

- (void) Shoot {
    [kam PlayShot];
    ammo--; kills++;
    state = 2;
}
- (void) DoneShooting {
    if ( ammo == 0 ) {
        [kam PlayClip];
        [parent performSelector:@selector(KidReloadToggle:) withObject:self];
        [self performSelector:@selector(Reload) withObject:nil afterDelay:reloadSpeed];
    }
    else {
        state = 0;
    }
}
- (void) Reload {
    if ( state != 3 ) {
        [kam PlayClip];
        ammo = ammoCap;
        state = 0;
        [parent performSelector:@selector(KidReloadToggle:) withObject:self];
    }
}
- (void) Countered {
    [kam PlayCounter];
}

- (void) Die {
    state = 3;
    [UIView animateWithDuration:0.8 animations:^(void){
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void) Select {
    active.hidden = NO;
}
- (void) Deselect {
    active.hidden = YES;
}

- (void) StartedMove {
    [kam PlayWalk];
}

@end
