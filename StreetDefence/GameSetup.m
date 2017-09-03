//
//  GameSetup.m
//  StreetDefence
//
//  Created by Freddie on 08/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "GameSetup.h"

#import "Kid.h"

@interface GameSetup ()

@end

@implementation GameSetup

@synthesize level;

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
    charSetup = [[LevelSetupCharacterPanel alloc] initWithFrame:CGRectMake(0, 0, 60, 320) Tags:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]]; /* This should change because 1 or more of these characters could be dead */
    [self.view addSubview:charSetup];
    lmp = [[LevelMapPlanning alloc] initWithFrame:CGRectMake(60, 0, [[UIScreen mainScreen] bounds].size.width-60, 320) Parent:self Level:level];
    [self.view addSubview:lmp];
    
    startButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.height-55, 265, 50, 50)];
    [startButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    [self.view addSubview:startButton]; startButton.hidden = YES;
    [startButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StartGame)]];
    
    team = [[UIButton alloc] initWithFrame:CGRectMake(5, 265, 51, 51)];
    [team setImage:[UIImage imageNamed:@"pickTeamButton.png"] forState:UIControlStateNormal];
    [team addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SelectTeam)]];
    [self.view addSubview:team];
    
    cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 320)];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 1;
}
- (void) viewWillAppear:(BOOL)animated {
    [charSetup removeFromSuperview];
    charSetup = [[LevelSetupCharacterPanel alloc] initWithFrame:CGRectMake(0, 0, 60, 320) Tags:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]];
    [self.view addSubview:charSetup];
    
    [lmp removeFromSuperview];
    lmp = [[LevelMapPlanning alloc] initWithFrame:CGRectMake(60, 0, [[UIScreen mainScreen] bounds].size.width-60, 320) Parent:self Level:level];
    [self.view addSubview:lmp];
    
    startButton.hidden = YES;
    [self.view bringSubviewToFront:team];
    [self.view bringSubviewToFront:startButton];
    
    [self.view addSubview:cover];
    cover.alpha = 1;
    [UIView animateWithDuration:0.8 animations:^(void){
        cover.alpha = 0;
    } completion:^(BOOL finished){
        [cover removeFromSuperview];
    }];
    
    if ( ![charSetup CanSelectTeam] ) { team.userInteractionEnabled = NO; }
}

- (void) StartGame {
    GameController *gc = [self.storyboard instantiateViewControllerWithIdentifier:@"gameScreen"];
    gc.kids = [charSetup GetKidsForGame];
    gc.level = level;
    
    [cover removeFromSuperview];
    cover.alpha = 0;
    [self.view addSubview:cover];
    
    [UIView animateWithDuration:0.8 animations:^(void){
        cover.alpha = 1;
    } completion:^(BOOL finished){
        [self.navigationController pushViewController:gc animated:NO];
    }];
}

- (void) SelectTeam {
    [teamSelect removeFromSuperview];
    teamSelect = [[TeamSelect alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 320) Parent:self];
    [self.view addSubview:teamSelect];
}
- (void) UpdateTeam:(NSMutableArray *)_newTeam {
    [teamSelect removeFromSuperview];
    
    [charSetup removeFromSuperview];
    charSetup = [[LevelSetupCharacterPanel alloc] initWithFrame:CGRectMake(0, 0, 60, 320) Tags:_newTeam];
    [self.view addSubview:charSetup];
    [self.view bringSubviewToFront:team];
    
    [lmp AddMarkers:[charSetup GetKidsForGame]];
    bool showStart = [charSetup CanStartGame];
    
    if ( showStart == YES ) { startButton.hidden = NO; }
    else { startButton.hidden = YES; }
}

- (void) CharacterMoved:(NSArray *)_newLocal {
    charSetup.current.startingLocation = CGPointMake([[_newLocal objectAtIndex:0] floatValue], [[_newLocal objectAtIndex:1] floatValue]);
    
    [lmp AddMarkers:[charSetup GetKidsForGame]];
    bool showStart = [charSetup CanStartGame];
    
    if ( showStart == YES ) { startButton.hidden = NO; }
    else { startButton.hidden = YES; }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
