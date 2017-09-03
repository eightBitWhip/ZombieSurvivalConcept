//
//  NewEnemyButton.m
//  StreetDefence
//
//  Created by Freddie on 16/06/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "NewEnemyButton.h"

@implementation NewEnemyButton

- (id) init {
    if ( self = [super initWithFrame:CGRectMake(10, 10, 150, 75)]) {
        int level = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"];
        
        if ( level == 2 || level == 3 || level == 4 ) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 75)];
            [button setImage:[UIImage imageNamed:@"newEnemy.png"] forState:UIControlStateNormal];
            [self addSubview:button];
        }
        else { self.hidden = YES; }
    }
    return self;
}
- (id) initWithParent:(NSObject *)_parent {
    if ( self = [super initWithFrame:CGRectMake(10, 10, 150, 75)]) {
        int level = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"];
        
        if ( level == 2 || level == 3 || level == 4 ) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 75)];
            [button setImage:[UIImage imageNamed:@"newEnemy.png"] forState:UIControlStateNormal];
            [self addSubview:button];
            [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_parent action:@selector(ShowEnemyView)]];
        }
        else { self.hidden = YES; }
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView*) GetNewEnemyView {
    [enemy removeFromSuperview];
    enemy = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 160)];
    enemy.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [enemy addSubview:[self GetEnemyPic]];
    [enemy addSubview:[self GetEnemyName]];
    [enemy addSubview:[self GetEnemyDesc]];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    close.frame = CGRectMake(220, 0, 30, 30);
    [close setTitle:@"x" forState:UIControlStateNormal];
    [enemy addSubview:close];
    [close addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideView)]];
    
    return enemy;
}

- (UIImageView*) GetEnemyPic {
    UIImageView *enemyPic = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 92, 92)];
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"]) {
        case 2:
            enemyPic.image = [UIImage imageNamed:@"zombieDogPolaroid.png"];
            break;
            
        case 3:
            enemyPic.image = [UIImage imageNamed:@"zombieBrutePolaroid.png"];
            break;
            
        case 4:
            enemyPic.image = [UIImage imageNamed:@"zombieSpitterPolaroid.png"];
            break;
            
        default:
            break;
    }
    
    return enemyPic;
}
- (UILabel*) GetEnemyName {
    UILabel *enemyTitle = [[UILabel alloc] initWithFrame:CGRectMake(106, 5, 130, 30)];
    enemyTitle.backgroundColor = [UIColor clearColor];
    enemyTitle.font = [UIFont fontWithName:@"Georgia" size:18.0f];
    enemyTitle.textColor = [UIColor whiteColor];
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"]) {
        case 2:
            enemyTitle.text = @"Zombie Dog";
            break;
            
        case 3:
            enemyTitle.text = @"Zombie Brute";
            break;
            
        case 4:
            enemyTitle.text = @"Zombie Spitter";
            break;
            
        default:
            break;
    }
    
    return enemyTitle;
}
- (UILabel*) GetEnemyDesc {
    UILabel *enemyDesc = [[UILabel alloc] initWithFrame:CGRectMake(106, 32, 130, 124)];
    enemyDesc.backgroundColor = [UIColor clearColor];
    enemyDesc.font = [UIFont fontWithName:@"Georgia" size:11.0f];
    enemyDesc.textColor = [UIColor whiteColor];
    enemyDesc.numberOfLines = 9;
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"]) {
        case 2:
            enemyDesc.text = @"Local dogs have been seen wondering the area. They are showing worrying signs of ferocity and one in particular was seen mauling an innocent. Watch out they have great speed, but are not particularly resiliant; one shot should be enough.";
            break;
            
        case 3:
            enemyDesc.text = @"Big zombie spotted throwing cars! Eye witnesses estimate a weight of 200Kg. Keep your distance these are highly resiliant zombies who will inflict heavy damage; eating people like candy.";
            break;
            
        case 4:
            enemyDesc.text = @"These walking health-hazards use their highly acidic saliva";
            break;
            
        default:
            break;
    }
    
    return enemyDesc;
}

- (void) HideView {
    [UIView animateWithDuration:0.3 animations:^(void){
        enemy.alpha = 0;
    } completion:^(BOOL finished){ [enemy removeFromSuperview]; }];
}

@end
