//
//  PathFindingUt.m
//  StreetDefence
//
//  Created by Freddie on 17/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "PathFindingUt.h"

@implementation PathFindingUt

- (id) initWithLevel:(int)_level {
    if ( self = [super init] ) {
        [self InitData:_level];
    }
    return self;
}

- (void) InitData:(int)_level {
    points = [[NSArray alloc] init];
    paths = [[NSArray alloc] init];
    
    NSString *primPath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [primPath stringByAppendingPathComponent:[NSString stringWithFormat:@"points%d.txt", _level]];
    
    points = [[NSArray alloc] initWithContentsOfFile:path];
    
    path = [primPath stringByAppendingPathComponent:[NSString stringWithFormat:@"paths%d.txt", _level]];
    
    paths = [[NSArray alloc] initWithContentsOfFile:path];
}

- (NSArray*) GetPoint:(int)_current Dest:(int)_dest {
    
    int pointRef = [[[paths objectAtIndex:_current] objectAtIndex:_dest] intValue];
    
    if ( pointRef == -1 ) return [NSArray arrayWithObjects:[NSNumber numberWithInt:-1], nil];
    else {
    return [points objectAtIndex:[[[paths objectAtIndex:_current] objectAtIndex:_dest] intValue]];
    }
}

@end
