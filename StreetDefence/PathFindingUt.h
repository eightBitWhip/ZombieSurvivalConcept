//
//  PathFindingUt.h
//  StreetDefence
//
//  Created by Freddie on 17/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathFindingUt : NSObject {
    NSArray *paths, *points;
}

- (id) initWithLevel:(int)_level;

- (void) InitData:(int)_level;

- (NSArray*) GetPoint:(int)_current Dest:(int)_dest;

@end
