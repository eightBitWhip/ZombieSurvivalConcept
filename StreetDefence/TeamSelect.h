//
//  TeamSelect.h
//  StreetDefence
//
//  Created by Freddie on 11/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SDLogo.h"

@interface TeamSelect : UIView {
    int amountSelected, pick1, pick2, pick3;
    NSMutableArray *characters;
    NSObject *parent;
    UIView *selectedScreen, *detailView, *highlight, *console;
    UIButton *confirmButton;
    SDLogo *picksSD;
}

- (id) initWithFrame:(CGRect)frame Parent:(NSObject*)_parent;

- (void) CharacterTouched:(UITapGestureRecognizer*)_selected;
- (void) CharacterSelected:(UITapGestureRecognizer*)_selected;
- (void) initChars;
- (void) Cancel;
- (void) Done;
- (void) AddCharToPicks:(float)_xPoint ImageName:(NSString*)_image;

- (void) AddDescBox;

@end
