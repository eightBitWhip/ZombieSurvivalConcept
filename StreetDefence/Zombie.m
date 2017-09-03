//
//  Zombie.m
//  StreetDefence
//
//  Created by Freddie on 09/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie

@synthesize room, destination, wayRoom, destRoom, wayPoint, hp, canSpit, type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithPoint:(CGPoint)_startPoint Type:(int)_type {
    if ( self = [super initWithFrame:CGRectMake(_startPoint.x, _startPoint.y, 6, 6)] ) {
        if ( _type == 1 ) {
            self.backgroundColor = [UIColor clearColor];
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            dot.image = [UIImage imageNamed:@"zombieMarker.png"];
            [self addSubview:dot];
            speed = 1; hp = 1;
        }
        else if ( _type == 2 ) {
            self.backgroundColor = [UIColor clearColor];
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            dot.image = [UIImage imageNamed:@"zombieDogMarker.png"];
            [self addSubview:dot];
            speed = 2; hp = 1;
        }
        else if ( _type == 3 ) {
            self.backgroundColor = [UIColor clearColor];
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            dot.image = [UIImage imageNamed:@"zombieBruteMarker.png"];
            [self addSubview:dot];
            speed = 1; hp = 3;
        }
        else if ( _type == 4 ) {
            self.backgroundColor = [UIColor clearColor];
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(-6, -6, 12, 12)];
            dot.image = [UIImage imageNamed:@"zombieSpitterMarker.png"];
            [self addSubview:dot];
            canSpit = YES;
            speed = 1; hp = 2;
        }
        type = _type;
    }
    return self;
}

- (void) Move {
    float newX = self.center.x, newY = self.center.y;
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
    
    /*if ( self.center.x == destination.x && self.center.y == destination.y ) {
        destination = CGPointMake(arc4random() % 300 + 10, arc4random() % 250 + 10);
    }*/
}

- (void) Die {
    dot.frame = CGRectMake(-2, -2, 10, 10);
    dot.image = [UIImage imageNamed:[NSString stringWithFormat:@"blood%d.png",arc4random()%3+1]];
    
    /*[UIView animateWithDuration:0.8 animations:^(void){
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];*/
}

- (void) ResetSpit {
    canSpit = YES;
}

@end
