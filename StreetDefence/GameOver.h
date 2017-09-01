//
//  GameOver.h
//  StreetDefence
//
//  Created by Freddie on 10/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GameOver : UIView

- (id) initWithParent:(NSObject*)_parent Score:(int)_score;

- (NSString*) ScoreRating:(int)_score;

@end
