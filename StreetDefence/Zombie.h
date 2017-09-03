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

@property (nonatomic) int room, wayRoom, destRoom, hp, type;
@property (nonatomic) CGPoint destination, wayPoint;
@property (nonatomic) bool canSpit;

- (id) initWithPoint:(CGPoint)_startPoint Type:(int)_type;

- (void) Move;
- (void) Die;
- (void) ResetSpit;

@end
