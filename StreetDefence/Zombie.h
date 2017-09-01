//
//  Zombie.h
//  StreetDefence
//
//  Created by Freddie on 09/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Zombie : UIView {
    float speed;
    UIImageView *dot;
}

@property (nonatomic) int room, wayRoom, destRoom, hp;
@property (nonatomic) CGPoint destination, wayPoint;

- (id) initWithPoint:(CGPoint)_startPoint Type:(int)_type;

- (void) Move;
- (void) Die;

@end
