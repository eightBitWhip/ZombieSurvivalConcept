//
//  LevelSelect.m
//  StreetDefence
//
//  Created by Freddie on 26/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "LevelSelect.h"

@interface LevelSelect ()

@end

@implementation LevelSelect

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 320)];
    [self.view addSubview:scroller];
    
    scroller.delegate = self;
    scroller.minimumZoomScale = 0.5; scroller.maximumZoomScale = 10;
    scroller.backgroundColor = [UIColor blackColor];
    scroller.contentSize = CGSizeMake(2500, 320);
    scroller.clipsToBounds = YES;
    
    levelsPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2500, 320)];
    levelsPanel.backgroundColor = [UIColor clearColor];
    [scroller addSubview:levelsPanel];
    
    resetPanel = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.height-240)/2, 70, 240, 180)];
    resetPanel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    UIImageView *resBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 180)];
    resBg.image = [UIImage imageNamed:@"resetBg.png"]; [resetPanel addSubview:resBg];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(135, 30, 70, 70)];
    [cancelButton setImage:[UIImage imageNamed:@"resetCancelButton.png"] forState:UIControlStateNormal];
    [resetPanel addSubview:cancelButton];
    [cancelButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Cancel)]];
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 30, 70, 70)];
    [resetButton setImage:[UIImage imageNamed:@"resetConfirmButton.png"] forState:UIControlStateNormal];
    [resetPanel addSubview:resetButton];
    [resetButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ResetGame)]];
    
    showReset = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.height-85, 5, 80, 25)];
    [showReset setImage:[UIImage imageNamed:@"resetGameButton.png"] forState:UIControlStateNormal];
    [self.view addSubview:showReset];
    [showReset addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ConfirmReset)]];
    
    cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 320)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0;
    
    footStepsLaid = 0;
}

- (void) viewWillAppear:(BOOL)animated {
    [cover removeFromSuperview];
    
    [self ResetView];
}

- (void) LevelPicked:(UITapGestureRecognizer *)_selected {
    GameSetup *gs = [self.storyboard instantiateViewControllerWithIdentifier:@"setupGame"];
    gs.level = _selected.view.tag;
    
    [self.view addSubview:cover];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^(void){
        [scroller zoomToRect:_selected.view.frame animated:NO];
        cover.alpha = 1;
    } completion:^(BOOL finished){
        scroller.zoomScale = 1.0;
        [self.navigationController pushViewController:gs animated:NO];
    }];
}

- (void) ConfirmReset {
    [resetPanel removeFromSuperview];
    resetPanel.alpha = 0;
    [self.view addSubview:resetPanel];
    [UIView animateWithDuration:0.3 animations:^(void){
        resetPanel.alpha = 1;
    }];
}
- (void) ResetGame {
    // RESET
    footStepsLaid = 0;
    
    NSString *primPath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [primPath stringByAppendingPathComponent:@"characters.plist"];
    NSMutableDictionary *charactersDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filesPath = [applicationDocumentsDir stringByAppendingPathComponent:@"characters.plist"];
    
    [charactersDict writeToFile:filesPath atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"currentLevel"];
    
    [cover removeFromSuperview]; cover.alpha = 0; [self.view addSubview:cover];
    [UIView animateWithDuration:0.4 animations:^(void){
        cover.alpha = 1;
        resetPanel.alpha = 0;
    } completion:^(BOOL finished){
        [self ResetView]; [self.view bringSubviewToFront:cover];
        [UIView animateWithDuration:0.4 animations:^(void){
            cover.alpha = 0;
        }];
    }];
}
- (void) Cancel {
    [UIView animateWithDuration:0.3 animations:^(void){
        resetPanel.alpha = 0;
    } completion:^(BOOL finished){
        [resetPanel removeFromSuperview];
    }];
}

- (void) ResetView {
    float footDelay = 0.5;
    CGPoint lastOrigin = CGPointMake(0, 140);
    
    [levelsPanel removeFromSuperview];
    
    levelsPanel.frame = CGRectMake(0, 0, 2500, 320);
    levelsPanel.backgroundColor = [UIColor clearColor];
    [scroller addSubview:levelsPanel];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2500, 320)];
    bg.image = [UIImage imageNamed:@"levelSelectBg.png"]; [levelsPanel addSubview:bg];
    
    NSArray *buttonData = [[NSArray alloc] init];
    NSString *primPath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [primPath stringByAppendingPathComponent:@"levelButtons.txt"];
    buttonData = [[NSArray alloc] initWithContentsOfFile:path];
    
    UIButton *previousLevel;
    UIImageView *previousCleared;
    
    for ( int i = 1; i <= 10; i++ ) {
        UIButton *levelButton;
        if ( i < 10 ) {
            levelButton = [[UIButton alloc] initWithFrame:CGRectMake([[[buttonData objectAtIndex:i-1] objectAtIndex:0] floatValue], [[[buttonData objectAtIndex:i-1] objectAtIndex:1] floatValue], [[[buttonData objectAtIndex:i-1] objectAtIndex:2] floatValue], [[[buttonData objectAtIndex:i-1] objectAtIndex:3] floatValue])];
            
            [levelButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%dbutton.png",i]] forState:UIControlStateNormal];
        }
        else {
            levelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            levelButton.frame = CGRectMake([[[buttonData objectAtIndex:i-1] objectAtIndex:0] floatValue], [[[buttonData objectAtIndex:i-1] objectAtIndex:1] floatValue], [[[buttonData objectAtIndex:i-1] objectAtIndex:2] floatValue], [[[buttonData objectAtIndex:i-1] objectAtIndex:3] floatValue]);
            [levelButton setTitle:[NSString stringWithFormat:@"Level %d",i] forState:UIControlStateNormal];
        }
        
        [levelsPanel addSubview:levelButton];
        if ( i == [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLevel"] intValue] ) {
            [levelButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LevelPicked:)]];
            levelButton.tag = i;
        }
        else { /*levelButton.alpha = 0.5;*/ levelButton.userInteractionEnabled = NO; }
        
        if ( i <= [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLevel"] intValue] ) {
            float yMod = (levelButton.center.y-lastOrigin.y)/((levelButton.center.x-lastOrigin.x)/20.0f);
            int yNum = 0;
            if ( i > footStepsLaid ) {
                for ( int j = lastOrigin.x; j < levelButton.center.x; j+=20 ) {
                    UIImageView *feet = [[UIImageView alloc] initWithFrame:CGRectMake(j, lastOrigin.y + yNum*yMod, 14, 14)];
                    feet.image = [UIImage imageNamed:@"footsteps.png"]; feet.alpha = 0;
                    [levelsPanel addSubview:feet];
                    feet.transform = CGAffineTransformMakeRotation(atan2f(levelButton.center.x-lastOrigin.x, lastOrigin.y-levelButton.center.y));
                    
                    [UIView animateWithDuration:0.4 delay:footDelay options:UIViewAnimationOptionCurveLinear animations:^(void){
                        feet.alpha = 1;
                    } completion:^(BOOL finished){}];
                    footDelay += 0.6;
                    yNum++;
                }
                footStepsLaid++;
            }
            else {
                for ( int j = lastOrigin.x; j < levelButton.center.x; j+=20 ) {
                    UIImageView *feet = [[UIImageView alloc] initWithFrame:CGRectMake(j, lastOrigin.y + yNum*yMod, 14, 14)];
                    feet.image = [UIImage imageNamed:@"footsteps.png"];
                    [levelsPanel addSubview:feet];
                    feet.transform = CGAffineTransformMakeRotation(atan2f(levelButton.center.x-lastOrigin.x, lastOrigin.y-levelButton.center.y));
                    yNum++;
                }
            }
        }
        [levelsPanel bringSubviewToFront:levelButton];
        lastOrigin = levelButton.center;
        
        UIImageView *cleared;
        
        if ( i < [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLevel"] intValue] ) {
            cleared = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            cleared.image = [UIImage imageNamed:@"levelCleared.png"];
            cleared.center = levelButton.center;
            [levelsPanel addSubview:cleared];
        }
        else if ( i > [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLevel"] intValue] ) {
            cleared = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            cleared.image = [UIImage imageNamed:@"padlock.png"];
            cleared.center = levelButton.center;
            [levelsPanel addSubview:cleared];
        }
        
        if ( previousLevel ) { [levelsPanel bringSubviewToFront:previousLevel]; }
        if ( previousCleared ) { [levelsPanel bringSubviewToFront:previousCleared]; }
        
        previousLevel = levelButton;
        previousCleared = cleared;
        
    }
    [self.view bringSubviewToFront:showReset];
    
    [newEnemy removeFromSuperview];
    newEnemy = [[NewEnemyButton alloc] initWithParent:self];
    newEnemy.center = CGPointMake([UIScreen mainScreen].bounds.size.height-78, 280);
    [self.view addSubview:newEnemy];
    
    [kidsStatus removeFromSuperview];
    kidsStatus = [[KidsStatus alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    [self.view addSubview:kidsStatus];
    
    /*UIImageView *dogMan = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    dogMan.animationDuration = 4;
    dogMan.animationRepeatCount = -1;
    
    NSMutableArray *doggies = [NSMutableArray new];
    for ( int i = 1; i <= 12; i++ ) {
        [doggies addObject:[UIImage imageNamed:[NSString stringWithFormat:@"dogFetch%d.png",i]]];
    }
    dogMan.animationImages = doggies;
    [levelsPanel addSubview:dogMan];
    [dogMan startAnimating];*/
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return levelsPanel;
}

- (void) ShowEnemyView {
    UIView *newEnemyDetails = [newEnemy GetNewEnemyView];
    newEnemyDetails.center = scroller.center;
    [self.view addSubview:newEnemyDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
