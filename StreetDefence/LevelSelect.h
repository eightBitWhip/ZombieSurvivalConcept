//
//  LevelSelect.h
//  StreetDefence
//
//  Created by Freddie on 26/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSetup.h"

#import "ZoomyScroll.h"
#import "KidsStatus.h"
#import "NewEnemyButton.h"

@interface LevelSelect : UIViewController <UIScrollViewDelegate> {
    UIView *resetPanel, *levelsPanel, *cover;
    UIScrollView *scroller;
    UIButton *showReset;
    
    KidsStatus *kidsStatus;
    NewEnemyButton *newEnemy;
    
    int footStepsLaid;
}

- (void) LevelPicked:(UITapGestureRecognizer*)_selected;
- (void) ConfirmReset;
- (void) ResetGame;

- (void) ResetView;
- (void) ShowEnemyView;

@end
