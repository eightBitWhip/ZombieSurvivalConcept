//
//  LevelSetupCharacterPanel.m
//  StreetDefence
//
//  Created by Freddie on 08/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "LevelSetupCharacterPanel.h"

#import "Kid.h"

@implementation LevelSetupCharacterPanel {
    NSMutableArray *faces;
}

@synthesize charSelected, current;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        charSelected = NO; [self initCharData];
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 320)];
        bg.image = [UIImage imageNamed:@"CharacterNavBg.png"];
        [self addSubview:bg];
        
        face1 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 30, 36, 36) Num:@"1"];
        [self addSubview:face1]; [face1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face1.tag = 0;
        
        face2 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 100, 36, 36) Num:@"2"];
        [self addSubview:face2]; [face2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face2.tag = 1;
        
        face3 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 170, 36, 36) Num:@"3"];
        [self addSubview:face3]; [face3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face3.tag = 2;
        
        selected = [[UIView alloc] initWithFrame:CGRectMake(11, 0, 38, 38)];
        selected.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        selected.alpha = 0; [self addSubview:selected];
    }
    return self;
}
- (id) initWithFrame:(CGRect)frame Tags:(NSMutableArray *)_tags {
    self = [super initWithFrame:frame];
    if (self) {
        charSelected = NO; [self initCharData];
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 320)];
        bg.image = [UIImage imageNamed:@"CharacterNavBg.png"];
        [self addSubview:bg];
        
        /*face1 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 30, 36, 36) KidPic:[NSString stringWithFormat:@"%@Port.png",[[charactersArr objectAtIndex:[[_tags objectAtIndex:0] intValue]] objectForKey:@"name"]]];
        [self addSubview:face1]; [face1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face1.tag = [[_tags objectAtIndex:0] intValue];
        
        face2 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 100, 36, 36) KidPic:[NSString stringWithFormat:@"%@Port.png",[[charactersArr objectAtIndex:[[_tags objectAtIndex:1] intValue]] objectForKey:@"name"]]];
        [self addSubview:face2]; [face2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face2.tag = [[_tags objectAtIndex:1] intValue];
        
        face3 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 170, 36, 36) KidPic:[NSString stringWithFormat:@"%@Port.png",[[charactersArr objectAtIndex:[[_tags objectAtIndex:2] intValue]] objectForKey:@"name"]]];
        [self addSubview:face3]; [face3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face3.tag = [[_tags objectAtIndex:2] intValue];*/
        
        faces = [[NSMutableArray alloc] initWithCapacity:3];
        float yPos = 30;
        
        for ( NSNumber *tag in _tags ) {
            
            if ( [charactersArr count] > [tag intValue] ) {
            
                CharacterIcon *face = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, yPos, 36, 36) KidPic:[NSString stringWithFormat:@"%@Port.png",[[charactersArr objectAtIndex:[tag intValue]] objectForKey:@"name"]]];
                [self addSubview:face]; [face addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
                face.tag = [tag intValue]; [faces addObject:face];
                yPos += 70;
                
            }
            
        }
        
        selected = [[UIView alloc] initWithFrame:CGRectMake(11, 0, 38, 38)];
        selected.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        selected.alpha = 0; [self addSubview:selected];
    }
    return self;
}
- (id) initWithFrame:(CGRect)frame Kids:(NSMutableArray *)_kids {
    self = [super initWithFrame:frame];
    if (self) {
        charSelected = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 320)];
        bg.image = [UIImage imageNamed:@"CharacterNavBg.png"];
        [self addSubview:bg];
        
        /*face1 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 30, 36, 36) KidPic:[NSString stringWithFormat:@"%@Port.png",[(Kid*)[_kids objectAtIndex:0] name]]];
        [self addSubview:face1]; [face1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face1.k = [_kids objectAtIndex:0];
        
        face1.k.ammoLabel = [self CreateAmmoLabel:CGRectMake(12, 69, 36, 20)];
        [self addSubview:face1.k.ammoLabel];
        
        face2 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 100, 36, 36) KidPic:[NSString stringWithFormat:@"%@Port.png",[(Kid*)[_kids objectAtIndex:1] name]]];
        [self addSubview:face2]; [face2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face2.k = [_kids objectAtIndex:1];
        
        face2.k.ammoLabel = [self CreateAmmoLabel:CGRectMake(12, 139, 36, 20)];
        [self addSubview:face2.k.ammoLabel];
        
        face3 = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, 170, 36, 36) KidPic:[NSString stringWithFormat:@"%@Port.png",[(Kid*)[_kids objectAtIndex:2] name]]];
        [self addSubview:face3]; [face3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
        face3.k = [_kids objectAtIndex:2];
        
        face3.k.ammoLabel = [self CreateAmmoLabel:CGRectMake(12, 209, 36, 20)];
        [self addSubview:face3.k.ammoLabel];*/
        
        faces = [[NSMutableArray alloc] initWithCapacity:3];
        float yPos = 30;
        
        for ( Kid *k in _kids ) {
            CharacterIcon *face = [[CharacterIcon alloc] initWithFrame:CGRectMake(12, yPos, 36, 36) KidPic:[NSString stringWithFormat:@"%@Port.png",[(Kid*)k name]]];
            [self addSubview:face]; [face addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharSelected:)]];
            face.k = k;
            
            face.k.ammoLabel = [self CreateAmmoLabel:CGRectMake(12, yPos+39, 36, 20)];
            [self addSubview:face.k.ammoLabel]; [faces addObject:face];
            yPos += 70;
        }
        
        selected = [[UIView alloc] initWithFrame:CGRectMake(11, 0, 38, 38)];
        selected.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        selected.alpha = 0; [self addSubview:selected];
    }
    return self;
}

- (void) CharSelected:(UITapGestureRecognizer *)_sender {
    CharacterIcon *touched = (CharacterIcon*)_sender.view;
    
    //[face1.k Deselect]; [face2.k Deselect]; [face3.k Deselect];
    for ( CharacterIcon *c in faces ) {
        [c.k Deselect];
    }
    
    if ( !touched.died ) {
        [touched.k Select];
        charSelected = YES; current = touched;
        selected.center = CGPointMake(selected.center.x, _sender.view.center.y);
        selected.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^(void){ selected.alpha = 0.5; }];
    }
}

- (void) KidDied:(Kid *)_kid {
    /*if ( face1.k == _kid ) { [face1 Dead]; }
    else if ( face2.k == _kid ) { [face2 Dead]; }
    else if ( face3.k == _kid ) { [face3 Dead]; }*/
    for ( CharacterIcon *c in faces ) {
        if ( c.k == _kid ) { [c Dead]; }
    }
}
- (void) KidReloadToggle:(Kid *)_kid {
    /*if ( face1.k == _kid ) { [face1 ReloadToggle]; }
    else if ( face2.k == _kid ) { [face2 ReloadToggle]; }
    else if ( face3.k == _kid ) { [face3 ReloadToggle]; }*/
    for ( CharacterIcon *c in faces ) {
        if ( c.k == _kid ) { [c ReloadToggle]; }
    }
}

- (NSMutableArray*) GetKidsForGame {
    NSMutableArray *kids = [[NSMutableArray alloc] init];
    
    /*if ( face1.startingLocation.x ) { Kid *k1 = [[Kid alloc] initData:[charactersArr objectAtIndex:face1.tag] Start:face1.startingLocation];
        [kids addObject:k1]; }
    
    if ( face2.startingLocation.x ) { Kid *k2 = [[Kid alloc] initData:[charactersArr objectAtIndex:face2.tag] Start:face2.startingLocation];
        [kids addObject:k2]; }
    
    if ( face3.startingLocation.x ) { Kid *k3 = [[Kid alloc] initData:[charactersArr objectAtIndex:face3.tag] Start:face3.startingLocation];
        [kids addObject:k3]; }*/
    for ( CharacterIcon *c in faces ) {
        if ( c.startingLocation.x ) {
            Kid *k = [[Kid alloc] initData:[charactersArr objectAtIndex:c.tag] Start:c.startingLocation];
            [kids addObject:k];
        }
    }
    
    return kids;
}
- (NSMutableArray*) GetKidsForLevelComplete {
    NSMutableArray *kids = [[NSMutableArray alloc] init];
    
    /*if ( face1.k ) { [kids addObject:face1.k]; }
    
    if ( face2.k ) { [kids addObject:face2.k]; }
    
    if ( face3.k ) { [kids addObject:face3.k]; }*/
    for ( CharacterIcon *c in faces ) {
        if ( c.k ) { [kids addObject:c.k]; }
    }
    
    return kids;
}

- (void) AddLabelToPic:(NSString*)_name Loc:(CGPoint)_loc {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    lab.backgroundColor = [UIColor clearColor]; lab.textColor = [UIColor greenColor];
    [lab setTextAlignment:NSTextAlignmentCenter];
    lab.text = _name;
    lab.font = [UIFont fontWithName:@"Georgia" size:10.0f];
    lab.center = _loc;
    [self addSubview:lab];
}

- (void) initCharData {
    charactersArr = [[NSMutableArray alloc] init];
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filesPath = [applicationDocumentsDir stringByAppendingPathComponent:@"characters.plist"];
    NSMutableDictionary *charactersDict = [NSMutableDictionary dictionaryWithContentsOfFile:filesPath];
    charactersArr = [charactersDict objectForKey:@"Characters"];
}

- (UILabel*) CreateAmmoLabel:(CGRect)_frame {
    UILabel *ammoLabel = [[UILabel alloc] initWithFrame:_frame];
    ammoLabel.backgroundColor = [UIColor clearColor];
    ammoLabel.textColor = [UIColor greenColor];
    ammoLabel.text = @"15/15";
    ammoLabel.font = [UIFont fontWithName:@"Courier" size:9.0f];
    [ammoLabel setTextAlignment:NSTextAlignmentRight];
    
    UIImageView *clip = [[UIImageView alloc] initWithFrame:CGRectMake(15, _frame.origin.y+2, 15, 15)];
    clip.image = [UIImage imageNamed:@"clip.png"];
    [self addSubview:clip];
    
    return ammoLabel;
}

- (BOOL) CanSelectTeam {
    if ( [charactersArr count] > 3 ) return YES;
    else return NO;
}

- (BOOL) CanStartGame {
    
    bool canStart = YES;
    
    for ( CharacterIcon *c in faces ) {
        if ( !c.startingLocation.x ) {
            canStart = NO;
        }
    }
    
    return canStart;
}

@end
