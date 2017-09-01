//
//  GameOver.m
//  StreetDefence
//
//  Created by Freddie on 10/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithParent:(NSObject *)_parent Score:(int)_score {
    if ( self = [super initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.height-20, 300)] ) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.layer.cornerRadius = 6;
        
        UIButton *retry = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        retry.frame = CGRectMake(self.frame.size.width/2-50, 120, 100, 30);
        [retry setTitle:@"Try Again?" forState:UIControlStateNormal];
        [retry addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_parent action:@selector(Retry)]];
        [self addSubview:retry];
        
        UILabel * score = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 40)];
        score.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        score.textColor = [UIColor brownColor];
        score.text = [self ScoreRating:_score];
        [score setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:score];
    }
    return self;
}

- (NSString*) ScoreRating:(int)_score {
    NSString *scoreRating = @"POO POO";
    if ( _score > 50 ) { scoreRating = [NSString stringWithFormat:@"A Terrible Score: %d",_score]; }
    if ( _score > 1500 ) { scoreRating = [NSString stringWithFormat:@"A Bad Score: %d",_score]; }
    if ( _score > 3000 ) { scoreRating = [NSString stringWithFormat:@"An Average Score: %d",_score]; }
    if ( _score > 8000 ) { scoreRating = [NSString stringWithFormat:@"A Good Score: %d",_score]; }
    if ( _score > 15000 ) { scoreRating = [NSString stringWithFormat:@"A Brilliant Score: %d",_score]; }
    return scoreRating;
}

@end
