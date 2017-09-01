//
//  CharacterIcon.m
//  StreetDefence
//
//  Created by Freddie on 08/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "CharacterIcon.h"

@implementation CharacterIcon

@synthesize startingLocation, k, died;

- (id)initWithFrame:(CGRect)frame Num:(NSString *)_num
{
    self = [super initWithFrame:frame];
    if (self) {
        died = NO;
        self.backgroundColor = [UIColor grayColor];
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.font = [UIFont fontWithName:@"Georgia" size:20.0f];
        [aLabel setText:_num]; [aLabel setTextColor:[UIColor lightGrayColor]];
        [aLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:aLabel];
        
        reload = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        reload.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:0.7];
        [self addSubview:reload];
        
        UILabel *deadLabel = [[UILabel alloc] initWithFrame:reload.frame];
        deadLabel.backgroundColor = [UIColor clearColor];
        deadLabel.font = [UIFont fontWithName:@"Georgia" size:12.0f];
        [deadLabel setText:@"Reloading"]; [deadLabel setTextColor:[UIColor blueColor]];
        [deadLabel setTextAlignment:NSTextAlignmentCenter];
        [reload addSubview:deadLabel];
        
        reload.hidden = YES;
    }
    return self;
}
- (id) initWithFrame:(CGRect)frame KidPic:(NSString *)_imageName {
    self = [super initWithFrame:frame];
    if (self) {
        died = NO;
        
        UIImageView *profPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        profPic.image = [UIImage imageNamed:_imageName];
        [self addSubview:profPic];
        
        reload = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        reload.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:0.7];
        [self addSubview:reload];
        
        UILabel *deadLabel = [[UILabel alloc] initWithFrame:reload.frame];
        deadLabel.backgroundColor = [UIColor clearColor];
        deadLabel.font = [UIFont fontWithName:@"Georgia" size:8.0f];
        [deadLabel setText:@"Reloading"]; [deadLabel setTextColor:[UIColor whiteColor]];
        [deadLabel setTextAlignment:NSTextAlignmentCenter];
        [reload addSubview:deadLabel];
        
        reload.hidden = YES;
    }
    return self;
}

- (void) Dead {
    died = YES;
    reload.hidden = YES;
    
    UIImageView *dead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    dead.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    dead.image = [UIImage imageNamed:@"dead.png"];
    [self addSubview:dead];
    
}

- (void) ReloadToggle {
    if ( !died ) {
        if ( reload.hidden == YES ) { reload.hidden = NO; }
        else { reload.hidden = YES; }
    }
}

@end
