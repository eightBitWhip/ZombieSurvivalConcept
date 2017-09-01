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
}

- (void) viewWillAppear:(BOOL)animated {
    [cover removeFromSuperview];
    
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
    
    for ( int i = 1; i <= 10; i++ ) {
        UIButton *levelButton;
        if ( i == 1 || i == 2 ) {
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
        else { levelButton.alpha = 0.5; levelButton.userInteractionEnabled = NO; }
        
    }
    [self.view bringSubviewToFront:showReset];
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
    NSString *primPath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [primPath stringByAppendingPathComponent:@"characters.plist"];
    NSMutableDictionary *charactersDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filesPath = [applicationDocumentsDir stringByAppendingPathComponent:@"characters.plist"];
    
    [charactersDict writeToFile:filesPath atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"currentLevel"];
}
- (void) Cancel {
    [UIView animateWithDuration:0.3 animations:^(void){
        resetPanel.alpha = 0;
    } completion:^(BOOL finished){
        [resetPanel removeFromSuperview];
    }];
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return levelsPanel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
