//
//  ZoomyScroll.m
//  StreetDefence
//
//  Created by Freddie on 29/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "ZoomyScroll.h"

@implementation ZoomyScroll

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame Parent:(NSObject *)_parent {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        parent = _parent;
    }
    return self;
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated
{
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [super zoomToRect:rect animated:YES];
    }
    completion:^(BOOL finished){
        [parent performSelector:@selector(StartPlanning)];
    }];
}

@end
