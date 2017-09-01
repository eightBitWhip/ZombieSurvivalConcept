//
//  LevelMapPlanning.h
//  StreetDefence
//
//  Created by Freddie on 09/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelMapPlanning : UIView {
    NSObject *parent;
    NSMutableArray *markers, *rooms;
}

- (id) initWithFrame:(CGRect)frame Parent:(NSObject*)_parent Level:(int)_level; // init with characters to enable markers to be established

- (BOOL) AddMarkers:(NSMutableArray*)_kids;

@end
