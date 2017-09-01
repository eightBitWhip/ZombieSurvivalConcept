//
//  LevelMapPlanning.m
//  StreetDefence
//
//  Created by Freddie on 09/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "LevelMapPlanning.h"

#import "Kid.h"

@implementation LevelMapPlanning {
    UIView *room1, *room2, *room3;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame Parent:(NSObject *)_parent Level:(int)_level {
    if ( self = [super initWithFrame:frame] ) {
        parent = _parent;
        rooms = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 420, 320)];
        bg.image = [UIImage imageNamed:@"planbg1.png"]; [self addSubview:bg];
        
        NSArray *roomData = [[NSArray alloc] init];
        NSString *primPath = [[NSBundle mainBundle] bundlePath];
        NSString *path = [primPath stringByAppendingPathComponent:[NSString stringWithFormat:@"rooms%d.txt", _level]];
        roomData = [[NSArray alloc] initWithContentsOfFile:path];
        
        for ( NSMutableArray *roomDat in roomData ) {
            if ( [[roomDat objectAtIndex:0] intValue] != -1 ) {
                UIView *room = [[UIView alloc] initWithFrame:CGRectMake([[roomDat objectAtIndex:0] floatValue], [[roomDat objectAtIndex:1] floatValue], [[roomDat objectAtIndex:2] floatValue], [[roomDat objectAtIndex:3] floatValue])];
                room.tag = [roomData indexOfObject:roomDat];
                room.backgroundColor = [UIColor brownColor];
                [self addSubview:room];
                [rooms addObject:room];
                if ( [roomDat count] == 5 ) {
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, room.frame.size.width, room.frame.size.height)];
                    img.image = [UIImage imageNamed:[roomDat objectAtIndex:4]];
                    [room addSubview:img];
                }
            }
        }
        
        /*room1 = [[UIView alloc] initWithFrame:CGRectMake(30, 20, 70, 70)];
        room1.backgroundColor = [UIColor redColor]; [self addSubview:room1];
        
        room2 = [[UIView alloc] initWithFrame:CGRectMake(100, 15, 170, 200)];
        room2.backgroundColor = [UIColor blueColor]; [self addSubview:room2];
        
        room3 = [[UIView alloc] initWithFrame:CGRectMake(270, 15, 50, 105)];
        room3.backgroundColor = [UIColor redColor]; [self addSubview:room3];*/
        
        markers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL) AddMarkers:(NSMutableArray *)_kids {
    int ready = 0;
    
    for ( UIView *u in markers ) {
        [u removeFromSuperview];
    }
    for ( Kid *k in _kids ) {
        if ( k.start.x ) {
            ready++;
            UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(k.start.x, k.start.y, 4, 4)];
            dot.backgroundColor = [UIColor yellowColor]; [self addSubview:dot];
            [markers addObject:dot];
        }
    }
    if ( ready == 3 ) { return YES; }
    else { return NO; }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocal = [touch locationInView:self];
    float x = touchLocal.x, y = touchLocal.y;
    bool placed = NO;
    
    for ( UIView *room in rooms ) {
        
        if ( (x > room.frame.origin.x && x < room.frame.origin.x+room.frame.size.width && y > room.frame.origin.y && y < room.frame.origin.y+room.frame.size.height) ) {
            NSArray *point = [NSArray arrayWithObjects:[NSNumber numberWithFloat:x], [NSNumber numberWithFloat:y], nil];
            [parent performSelector:@selector(CharacterMoved:) withObject:point];
            placed = YES;
        }
    }
    if ( !placed ) {
        UILabel *error = [[UILabel alloc] initWithFrame:CGRectMake(60, 202, 300, 40)];
        error.text = @"Units must be placed inside the house!";
        [self addSubview:error];
        [UIView animateWithDuration:.5 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^(void){ error.alpha = 0; } completion:^(BOOL finished){ [error removeFromSuperview]; }];
    }
}

@end
