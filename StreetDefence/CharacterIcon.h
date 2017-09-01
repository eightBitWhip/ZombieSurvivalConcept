//
//  CharacterIcon.h
//  StreetDefence
//
//  Created by Freddie on 08/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Kid.h"

@interface CharacterIcon : UIView {
    UIView *reload;
}

@property (nonatomic) CGPoint startingLocation;
@property (nonatomic) Kid *k;
@property (nonatomic) bool died;

- (id) initWithFrame:(CGRect)frame Num:(NSString*)_num;
- (id) initWithFrame:(CGRect)frame KidPic:(NSString*)_imageName;

- (void) Dead;
- (void) ReloadToggle;

@end
