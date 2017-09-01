//
//  SDLogo.m
//  StreetDefence
//
//  Created by Freddie on 21/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "SDLogo.h"

@implementation SDLogo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        logo.image = [UIImage imageNamed:@"sdlogo1.png"]; [self addSubview:logo];
        
        logo.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"sdlogo1.png"], [UIImage imageNamed:@"sdlogo2.png"], [UIImage imageNamed:@"sdlogo3.png"], [UIImage imageNamed:@"sdlogo4.png"], nil];
        logo.animationDuration = 1.5;
        logo.animationRepeatCount = -1;
        
        [logo startAnimating];
    }
    return self;
}

@end
