//
//  GameController.m
//  StreetDefence
//
//  Created by Freddie on 08/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "GameController.h"

#import "DataManager.h"

#import "Kid.h"

#define READY 0
#define MOVING 1
#define SHOOTING 2
#define DEAD 3

@interface GameController () {
    UILabel *scoreLabel;
    bool paused;
    NSMutableArray *deadKids, *spitPatches;
}

@end

@implementation GameController

@synthesize kids, aVPlayer, level;

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
    zombies = [[NSMutableArray alloc] init];
    rooms = [[NSMutableArray alloc] init];
    zomStarts = [[NSMutableArray alloc] init];
    deadKids = [[NSMutableArray alloc] init];
    spitPatches = [[NSMutableArray alloc] init];
    score = 0; zombieCount = 0;
    pfut = [[PathFindingUt alloc] initWithLevel:level];
    paused = NO;
    
    mapScreen = [[UIView alloc] initWithFrame:CGRectMake(60/*+(([[UIScreen mainScreen] bounds].size.height-480)/2)*/, 0, [UIScreen mainScreen].bounds.size.width - 60, 320)];
    mapScreen.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mapScreen];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 420, 320)];
    bg.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%d.png",level]]; [mapScreen addSubview:bg];
    
    characterPanel = [[LevelSetupCharacterPanel alloc] initWithFrame:CGRectMake(0, 0, 60, 320) Kids:kids];
    [self.view addSubview:characterPanel];
    
    UIButton *team = [[UIButton alloc] initWithFrame:CGRectMake(5, 265, 51, 51)];
    [team setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
    [team addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Pause)]];
    [self.view addSubview:team];
    
    NSString *primPath = [[NSBundle mainBundle] bundlePath];
    NSString *pathz = [primPath stringByAppendingPathComponent:[NSString stringWithFormat:@"zombieStarts%d.txt", level]];
    zomStarts = [[NSMutableArray alloc] initWithContentsOfFile:pathz];
    
    NSString *patht = [primPath stringByAppendingPathComponent:[NSString stringWithFormat:@"zombieTypes%d.txt", level]];
    zombieTypes = [[NSArray alloc] initWithContentsOfFile:patht];
    
    NSArray *roomData = [[NSArray alloc] init];
    NSString *path = [primPath stringByAppendingPathComponent:[NSString stringWithFormat:@"rooms%d.txt", level]];
    roomData = [[NSArray alloc] initWithContentsOfFile:path];
    
    for ( NSMutableArray *roomDat in roomData ) {
        if ( [[roomDat objectAtIndex:0] intValue] != -1 ) {
            UIView *room = [[UIView alloc] initWithFrame:CGRectMake([[roomDat objectAtIndex:0] floatValue], [[roomDat objectAtIndex:1] floatValue], [[roomDat objectAtIndex:2] floatValue], [[roomDat objectAtIndex:3] floatValue])];
            room.tag = [roomData indexOfObject:roomDat];
            room.backgroundColor = [UIColor brownColor];
            [mapScreen addSubview:room];
            [rooms addObject:room];
            if ( [roomDat count] == 5 ) {
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, room.frame.size.width, room.frame.size.height)];
                img.image = [UIImage imageNamed:[roomDat objectAtIndex:4]];
                [room addSubview:img];
            }
        }
    }
    
    for ( Kid *k in kids ) {
        [mapScreen addSubview:k];
        k.parent = characterPanel;
    }
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.height - 100, 10, 90, 20)];
    scoreLabel.font = [UIFont fontWithName:@"Courier" size:18.0f];
    scoreLabel.text = @"0";
    scoreLabel.textColor = [UIColor greenColor];
    [scoreLabel setTextAlignment:NSTextAlignmentRight];
    scoreLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scoreLabel];
    
    [self SetKidsRooms];
    
    gameTimer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(GameLoop) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:gameTimer forMode:NSRunLoopCommonModes];
}

- (void) viewDidAppear:(BOOL)animated {
    NSString *audioPathZoms = [NSString stringWithFormat:@"%@/audioZombies.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *zoms = [NSURL fileURLWithPath:audioPathZoms];
    
    @try {
        NSError *error;
        aVPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:zoms error:&error];
        [aVPlayer setNumberOfLoops:-1];
        [aVPlayer prepareToPlay];
        [aVPlayer play];
        
        if ( error ) NSLog(@"%@",error);
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
    }
}

- (void) GameLoop {
    
    if ( paused == NO ) {
    
        [self CheckCollisions];
        [self MoveZombies];
        [self AddZombie];
        
        if ( [kids count] == 0 ) {
            [self GameOver];
        }
        if ( [zombies count] == 0 && zombieCount == 200 ) {
            // WINNER!!
            // LEVEL UP KIDS STILL ALIVE
            // LEVEL UP POINTS BASED ON KILLS: 1 Per 30% of total zombies.
            // POINTS = totalKills / (zombiesTotal * .3)
            [self LevelComplete];
        }
        scoreLabel.text = [NSString stringWithFormat:@"%d",score];
        
    }
}

- (void) CheckCollisions {
    score++;
    
    for ( Kid *k in kids ) {
        
        if ( k.state == MOVING ) {
            [k Move];
            if ( k.state == MOVING && k.center.x == k.wayPoint.x && k.center.y == k.wayPoint.y ) {
                [self KidSetNewWay:k];
            }
        }
        
        NSMutableArray *deadZombies = [NSMutableArray new];
        for ( Zombie *z in zombies ) {
            if ( z.center.x - k.center.x < 50 && z.center.x - k.center.x > -50 && z.center.y - k.center.y < 50 && z.center.y - k.center.y > -50 ) {
                //z.destRoom = k.room;
                //z.wayRoom = k.room;
                //z.destination = k.center;
                // THIS NEEDS TO BE DONE PROPERLY BECAUSE IT'S NOT WORKING
            }
            
            float range = 35; if ( k.longRange == YES ) { range = 50; }
            
            if ( z.center.x - k.center.x < range && z.center.x - k.center.x > -range && z.center.y - k.center.y < range && z.center.y - k.center.y > -range && k.state != SHOOTING && k.state != MOVING && k.ammo > 0 /*&& k.room == z.room this check doesn't currently work because zombies move from door to door sometimes. create an array which stores valid rooms for each kid room shot */ ) {
                [k Shoot];
                [k performSelector:@selector(DoneShooting) withObject:nil afterDelay:k.triggerSpeed];
                z.hp--;
                if ( z.hp == 0 ) {
                    [z Die];
                    [deadZombies addObject:z];
                }
            }
            else if ( z.center.x - k.center.x < 10 && z.center.x - k.center.x > -10 && z.center.y - k.center.y < 10 && z.center.y - k.center.y > -10 ) {
                if ( k.closeQuarters == YES && arc4random() % 5 + 1 != 3 ) {
                    [k Countered];
                    [self ShowEventMessage:1];
                    z.hp--;
                    if ( z.hp == 0 ) {
                        [z Die];
                        [deadZombies addObject:z];
                    }
                }
                else {
                    [k Die];
                    break;
                }
            }
        }
        score += [deadZombies count]*25;
        [zombies removeObjectsInArray:deadZombies];
        
        for ( UIImageView *spit in spitPatches ) {
            if ( CGRectIntersectsRect(k.frame, spit.frame) ) {
                [k Die];
                break;
            }
        }
        
        int ammoMax = 15; if ( k.extraAmmo == YES ) { ammoMax = 25; }
        k.ammoLabel.text = [NSString stringWithFormat:@"%d/%d", k.ammo, ammoMax];
    }
    for ( int i = 0; i < [kids count]; i++ ) {
        @try {
            Kid *k = [kids objectAtIndex:i];
            if ( k.state == DEAD ) {
                [kids removeObject:k];
                [deadKids addObject:k];
                [characterPanel KidDied:k];
            }
        }
        @catch (NSException *e) {
            NSLog(@"%@", e);
        }
    }
    for ( int i = 0; i < [spitPatches count]; i++ ) {
        @try {
            UIImageView *spit = [spitPatches objectAtIndex:i];
            if ( spit.tag == -1 ) {
                [spitPatches removeObject:spit];
            }
        }
        @catch (NSException *e) {
            NSLog(@"%@", e);
        }
    }
}

- (void) MoveZombies {
    for ( Zombie *z in zombies ) {
        if ( arc4random() % 2 + 1 == 1 ) {
            if ( z.center.x == z.destination.x && z.center.y == z.destination.y ) {
                [self ZomSetNewDest:z];
            }
            if ( z.center.x == z.wayPoint.x && z.center.y == z.wayPoint.y ) {
                [self ZomSetNewWay:z];
            }
            [z Move];
        }
        if ( z.type == 4 && z.canSpit && arc4random() % 4 == 2 ) {
            [self AddSpit:CGPointMake(z.center.x-20+arc4random()%40, z.center.y-20+arc4random()%40)];
            z.canSpit = NO;
            [z performSelector:@selector(ResetSpit) withObject:nil afterDelay:4];
        }
    }
}

- (void) AddZombie { /* Get Locations from data file. Data file should contain x, y and room number waypoint. set Zombie.room to -1 because it needs a value and way point to destination. Set Zombie paths in same way as kids, and check if in the same room before locking on */
    if ( arc4random() % 10 + 1 == 5 && zombieCount < 200 && paused == NO ) {
        
        NSMutableArray *zDat = [zomStarts objectAtIndex:arc4random() % 8];
        
        Zombie *z = [[Zombie alloc] initWithPoint:CGPointMake([[zDat objectAtIndex:0] floatValue], [[zDat objectAtIndex:1] floatValue]) Type:[[[zombieTypes objectAtIndex:zombieCount] objectAtIndex:0] intValue]];
        z.destination = CGPointMake([[zDat objectAtIndex:2] floatValue], [[zDat objectAtIndex:3] floatValue]);
        z.wayPoint = z.destination;
        z.destRoom = [[zDat objectAtIndex:4] intValue];
        z.wayRoom = z.destRoom;
        z.room = -1;
        
        [mapScreen addSubview:z]; [zombies addObject:z];
        zombieCount++;
    }
}

- (void) Pause {
    if ( paused == NO ) { paused = YES; }
    else { paused = NO; }
}

- (void) LevelComplete {
    // Could save state here to give points to kids and dead stay dead
    [DataManager RemoveDeadKids:deadKids];
    paused = YES;
    score += [kids count] * 1000; // Add time bonus also
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    LevelCompletePanel *lcp = [[LevelCompletePanel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-440)/2, 13, 440, 294) Parent:self Kids:kids Score:score Zombies:200];
    [self.view addSubview:lcp];
}

- (void) GameOver {
    [gameTimer invalidate];
    [DataManager RemoveDeadKids:deadKids];
    GameOver *gameOver = [[GameOver alloc] initWithParent:self Score:score];
    [self.view addSubview:gameOver];
}
- (void) Retry {
    zombies = nil;
    kids = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( characterPanel.current ) {
        
        UITouch *touch = [touches anyObject];
        CGPoint touchLocal = [touch locationInView:mapScreen];
        //characterPanel.current.k.destination = touchLocal;
        //characterPanel.current.k.state = MOVING;
        
        // Still need to setup waypoint marking, marking current/new room and target room
        
        float x = touchLocal.x, y = touchLocal.y;
        
        for ( UIView *room in rooms ) {
            
            if ( (x > room.frame.origin.x && x < room.frame.origin.x+room.frame.size.width && y > room.frame.origin.y && y < room.frame.origin.y+room.frame.size.height) ) {
                
                [characterPanel.current.k StartedMove];
                
                if ( room.tag == characterPanel.current.k.room ) {
                    characterPanel.current.k.destination = touchLocal;
                    characterPanel.current.k.wayPoint = touchLocal;
                    characterPanel.current.k.destRoom = room.tag;
                    characterPanel.current.k.state = MOVING;
                }
                else {
                    NSArray *newLocal = [pfut GetPoint:characterPanel.current.k.room Dest:room.tag];
                    
                    characterPanel.current.k.destRoom = room.tag;
                    characterPanel.current.k.destination = touchLocal;
                    
                    if ( [[newLocal objectAtIndex:0] intValue] == -1 ) {
                        
                        characterPanel.current.k.wayRoom = room.tag;
                        characterPanel.current.k.wayPoint = touchLocal;
                        characterPanel.current.k.state = MOVING;
                        
                    }
                    else {
                        
                        characterPanel.current.k.wayPoint = CGPointMake([[newLocal objectAtIndex:0] floatValue], [[newLocal objectAtIndex:1] floatValue]);
                        characterPanel.current.k.wayRoom = [[newLocal objectAtIndex:2] intValue];
                        characterPanel.current.k.state = MOVING;
                        
                    }
                }
                
            }
            
        }
    }
}

- (void) SetKidsRooms {
    for ( Kid *k in kids ) {
        float x = k.center.x, y = k.center.y;
        
        for ( UIView *room in rooms ) {
            
            if ( (x > room.frame.origin.x && x < room.frame.origin.x+room.frame.size.width && y > room.frame.origin.y && y < room.frame.origin.y+room.frame.size.height) ) {
                k.room = room.tag;
            }
            
        }
    }
}

- (void) KidSetNewWay:(Kid*)_kid {
    _kid.room = _kid.wayRoom;
    
    NSArray *newLocal = [pfut GetPoint:_kid.room Dest:_kid.destRoom];
        
    if ( [[newLocal objectAtIndex:0] intValue] == -1 ) {
        
        _kid.wayRoom = _kid.destRoom;
        _kid.wayPoint = _kid.destination;
        
    }
    else {
        
        _kid.wayPoint = CGPointMake([[newLocal objectAtIndex:0] floatValue], [[newLocal objectAtIndex:1] floatValue]);
        _kid.wayRoom = [[newLocal objectAtIndex:2] intValue];
        
    }
}
- (void) ZomSetNewWay:(Zombie *)_zombie {
    _zombie.room = _zombie.wayRoom;
    
    NSArray *newLocal = [pfut GetPoint:_zombie.room Dest:_zombie.destRoom];
    
    if ( [[newLocal objectAtIndex:0] intValue] == -1 ) {
        
        _zombie.wayRoom = _zombie.destRoom;
        _zombie.wayPoint = _zombie.destination;
        
    }
    else {
        
        _zombie.wayPoint = CGPointMake([[newLocal objectAtIndex:0] floatValue], [[newLocal objectAtIndex:1] floatValue]);
        _zombie.wayRoom = [[newLocal objectAtIndex:2] intValue];
        
    }
}
- (void) ZomSetNewDest:(Zombie *)_zombie {
    _zombie.room = _zombie.destRoom;
    
    UIView *room = [rooms objectAtIndex:arc4random() % 5];
    
    CGPoint newDest = CGPointMake(room.frame.origin.x + arc4random() % 20 + 10, room.frame.origin.y + arc4random() % 20 + 10);
    
    if ( room.tag == _zombie.room ) {
        _zombie.destination = newDest;
        _zombie.wayPoint = newDest;
        _zombie.destRoom = room.tag;
    }
    else {
        NSArray *newLocal = [pfut GetPoint:_zombie.room Dest:room.tag];
        
        _zombie.destRoom = room.tag;
        _zombie.destination = newDest;
        
        if ( [[newLocal objectAtIndex:0] intValue] == -1 ) {
            
            _zombie.wayRoom = room.tag;
            _zombie.wayPoint = newDest;
            
        }
        else {
            
            _zombie.wayPoint = CGPointMake([[newLocal objectAtIndex:0] floatValue], [[newLocal objectAtIndex:1] floatValue]);
            _zombie.wayRoom = [[newLocal objectAtIndex:2] intValue];
            
        }
    }
}

- (void) LevelFinishedPointsDone {
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 320)];
    cover.backgroundColor = [UIColor blackColor]; cover.alpha = 0;
    [self.view addSubview:cover];
    
    if ( level < 3 ) { [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:level+1] forKey:@"currentLevel"]; }
    
    [UIView animateWithDuration:0.8 animations:^(void){
        cover.alpha = 1;
    } completion:^(BOOL finished){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

- (void) ShowEventMessage:(int)_type {
    [eventMessage removeFromSuperview];
    eventMessage = [[UIView alloc] initWithFrame:CGRectMake(140, 80, 200, 140)];
    eventMessage.backgroundColor = [UIColor clearColor]; eventMessage.alpha = .6;
    
    UIImageView *eventImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 30, 80, 80)];
    [eventMessage addSubview:eventImage];
    
    UILabel *eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 140)];
    eventLabel.textAlignment = UITextAlignmentCenter; eventLabel.textColor = [UIColor greenColor];
    eventLabel.backgroundColor = [UIColor clearColor]; eventLabel.font = [UIFont fontWithName:@"Raconteur NF" size:26.0f]; [eventMessage addSubview:eventLabel];
    
    switch (_type) {
        case 1:
            eventLabel.text = @"Knife Save!";
            eventImage.image = [UIImage imageNamed:@"perkclose.png"];
            break;
            
        default:
            break;
    }
    
    [self.view addSubview:eventMessage];
    
    [UIView animateWithDuration:2.5 animations:^(void){
        eventMessage.alpha = 0;
        eventMessage.transform = CGAffineTransformMakeRotation(2.3);
        eventImage.frame = CGRectMake(60, 10, 120, 120);
        eventLabel.font = [UIFont fontWithName:@"Raconteur NF" size:32.0f];
    } completion:^(BOOL finished){ [eventMessage removeFromSuperview]; }];
}

- (void) AddSpit:(CGPoint)_local {
    UIImageView *spit = [[UIImageView alloc] initWithFrame:CGRectMake(_local.x, _local.y, 18, 18)];
    spit.image = [UIImage imageNamed:@"spit1.png"]; [mapScreen addSubview:spit]; spit.tag = 1;
    [spitPatches addObject:spit];
    
    [UIView animateWithDuration:1.5 delay:4 options:UIViewAnimationOptionCurveLinear animations:^(void){
        spit.alpha = 0;
    } completion:^(BOOL finished){
        [spit removeFromSuperview];
        spit.tag = -1;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
