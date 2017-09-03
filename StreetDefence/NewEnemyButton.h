//
//  NewEnemyButton.h
//  StreetDefence
//
//  Created by Freddie on 16/06/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEnemyButton : UIView {
    UIView *enemy;
}

- (id) initWithParent:(NSObject*)_parent;

- (void) HideView;

- (UIView*) GetNewEnemyView;
- (UIImageView*) GetEnemyPic;
- (UILabel*) GetEnemyName;
- (UILabel*) GetEnemyDesc;

@end
