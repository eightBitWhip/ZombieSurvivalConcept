//
//  LevelCompletePanel.m
//  StreetDefence
//
//  Created by Freddie on 22/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "LevelCompletePanel.h"

#import "Kid.h"

@implementation LevelCompletePanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame Parent:(NSObject *)_parent Kids:(NSMutableArray *)_kids Score:(int)_score Zombies:(int)_zombieCount {
    if ( self = [super initWithFrame:frame] ) {
        parent = _parent; zombieCount = _zombieCount;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bg.image = [UIImage imageNamed:@"levelCompleteConsole.png"];
        [self addSubview:bg];
        
        upgrades1 = [[NSMutableArray alloc] init];
        upgrades2 = [[NSMutableArray alloc] init];
        upgrades3 = [[NSMutableArray alloc] init];
        
        kids = _kids;
        
        /* add score and kid pics to show alive/dead, and gesture to show upgrade screen for that kid. Store unused points in data 
         
         upgrade panel should have 3 pics with dead / alive status and underneath kills / dodges made etc. if alive another panel should bring up upgrade options: stats and perks
         
         undo button will remove last allocation. allocations stored in array to check last. all stats updated after each allocation/deallocation to change text colour if affected
         */
        
        UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(40, 14, frame.size.width, 40)];
        summary.backgroundColor = [UIColor clearColor]; summary.font = [UIFont fontWithName:@"Courier" size:20.0f];
        summary.textColor = [UIColor greenColor];
        [summary setTextAlignment:NSTextAlignmentCenter];
        summary.text = [NSString stringWithFormat:@"Summary: %d points", _score];
        [self addSubview:summary];
        
        UILabel *survivors = [[UILabel alloc] initWithFrame:CGRectMake(17, 16, 84, 40)];
        survivors.backgroundColor = [UIColor clearColor]; survivors.font = [UIFont fontWithName:@"Courier" size:13.0f];
        survivors.textColor = [UIColor greenColor];
        [survivors setTextAlignment:NSTextAlignmentCenter];
        survivors.text = @"Survivors";
        [self addSubview:survivors];
        
        undoButton = [[UIButton alloc] initWithFrame:CGRectMake(344, 264, 40, 25)];
        [undoButton setImage:[UIImage imageNamed:@"undoBlue.png"] forState:UIControlStateNormal];
        [undoButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Undo)]];
        [self addSubview:undoButton];
        undoButton.userInteractionEnabled = NO;
        
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(390, 264, 25, 25)];
        [doneButton setImage:[UIImage imageNamed:@"confirmGreen.png"] forState:UIControlStateNormal];
        [doneButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Done)]];
        [self addSubview:doneButton];
        
        // add chars here
        for ( int i = 0; i < [kids count]; i++ ) {
            Kid *k = [kids objectAtIndex:i];
            
            UIButton *kBut = [[UIButton alloc] initWithFrame:CGRectMake(32, (i+1)*68, 40, 40)];
            [kBut setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Port.png",k.name]] forState:UIControlStateNormal];
            kBut.tag = i;
            [self addSubview:kBut];
            [kBut addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KidSelected:)]];
            
            UILabel *kills = [[UILabel alloc] initWithFrame:CGRectMake(30, kBut.frame.origin.y+38, 60, 20)];
            kills.center = CGPointMake(kBut.center.x, kills.center.y);
            [kills setTextAlignment:NSTextAlignmentCenter];
            kills.backgroundColor = [UIColor clearColor];
            kills.textColor = [UIColor colorWithWhite:0.8 alpha:1];
            kills.font = [UIFont fontWithName:@"Georgia" size:9.0f];
            kills.text = [NSString stringWithFormat:@"Kills: %d",k.kills];
            [self addSubview:kills];
        }
        
        highlight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        highlight.backgroundColor = [UIColor clearColor];
        highlight.image = [UIImage imageNamed:@"highlight.png"];
        [self addSubview:highlight]; highlight.hidden = YES;
    }
    return self;
}

- (void) KidSelected:(UITapGestureRecognizer *)_sender {
    // Load panel data with kid from array using tag
    currentKid = _sender.view.tag;
    
    highlight.center = _sender.view.center;
    highlight.hidden = NO;
    
    [self ShowUpgradePanel];
}
- (void) PerkStatSelected:(UITapGestureRecognizer *)_sender {
    UIButton *sP = (UIButton*)_sender.view;
    
    NSMutableArray *uCheck;
    if ( currentKid == 0 ) { uCheck = upgrades1; }
    else if ( currentKid == 1 ) { uCheck = upgrades2; }
    else { uCheck = upgrades3; }
    
    if ( [self CanAfford] >= _sender.view.tag ) {
        // Add to upgrades
        if ( sP == speedB ) { [uCheck addObject:@"speed"]; }
        else if ( sP == triggerB ) { [uCheck addObject:@"trigger"]; }
        else if ( sP == reloadB ) { [uCheck addObject:@"reload"]; }
        else { [uCheck addObject:sP.titleLabel.text]; }
    }
    [self ShowUpgradePanel];
}

- (void) ShowUpgradePanel {
    Kid *k = [kids objectAtIndex:currentKid];
    
    [upgradesPanel removeFromSuperview];
    upgradesPanel = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-302, 50, 260, 230)];
    upgradesPanel.backgroundColor = [UIColor clearColor];
    [self addSubview:upgradesPanel];
    
    UILabel *points = [[UILabel alloc] initWithFrame:CGRectMake(28, 30, 140, 20)];
    points.backgroundColor = [UIColor clearColor];
    points.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    points.font = [UIFont fontWithName:@"Georgia" size:10.0f];
    points.text = [NSString stringWithFormat:@"Points Available: %d",[self CanAfford]];
    [upgradesPanel addSubview:points];
    
    speedB = [[UIButton alloc] initWithFrame:CGRectMake(10, 68, 56, 20)];
    [upgradesPanel addSubview:speedB];
    [speedB setBackgroundImage:[UIImage imageNamed:@"speedStatButton.png"] forState:UIControlStateNormal];
    float sCheck = [self CheckPoints:@"speed"];
    if ( sCheck == 0 ) {
        [upgradesPanel addSubview:[self CreateButtonLabel:speedB.frame Color:[UIColor whiteColor] Text:[NSString stringWithFormat:@"%.1f",k.speed]]];
    }
    else {
        [upgradesPanel addSubview:[self CreateButtonLabel:speedB.frame Color:[UIColor greenColor] Text:[NSString stringWithFormat:@"%.1f",k.speed+sCheck]]];
    }
    speedB.tag = 1;
    [speedB addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PerkStatSelected:)]];
    if ( k.speed + sCheck > 3.4 ) { speedB.userInteractionEnabled = NO; }
    
    reloadB = [[UIButton alloc] initWithFrame:CGRectMake(76, 68, 56, 20)];
    [upgradesPanel addSubview:reloadB];
    [reloadB setBackgroundImage:[UIImage imageNamed:@"reloadStatButton.png"] forState:UIControlStateNormal];
    float rCheck = [self CheckPoints:@"reload"];
    if ( rCheck == 0 ) {
        [upgradesPanel addSubview:[self CreateButtonLabel:reloadB.frame Color:[UIColor whiteColor] Text:[NSString stringWithFormat:@"%.1f",k.reloadSpeed]]];
    }
    else {
        [upgradesPanel addSubview:[self CreateButtonLabel:reloadB.frame Color:[UIColor greenColor] Text:[NSString stringWithFormat:@"%.1f",k.reloadSpeed-rCheck]]];
    }
    reloadB.tag = 1;
    [reloadB addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PerkStatSelected:)]];
    if ( k.reloadSpeed - rCheck < 3.6 ) { reloadB.userInteractionEnabled = NO; }
    
    triggerB = [[UIButton alloc] initWithFrame:CGRectMake(48, 98, 56, 20)];
    [upgradesPanel addSubview:triggerB];
    [triggerB setBackgroundImage:[UIImage imageNamed:@"triggerStatButton.png"] forState:UIControlStateNormal];
    float tCheck = [self CheckPoints:@"trigger"];
    if ( tCheck == 0 ) {
        [upgradesPanel addSubview:[self CreateButtonLabel:triggerB.frame Color:[UIColor whiteColor] Text:[NSString stringWithFormat:@"%.1f",k.triggerSpeed]]];
    }
    else {
        [upgradesPanel addSubview:[self CreateButtonLabel:triggerB.frame Color:[UIColor greenColor] Text:[NSString stringWithFormat:@"%.1f",k.triggerSpeed-tCheck]]];
    }
    triggerB.tag = 1;
    [triggerB addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PerkStatSelected:)]];
    if ( k.triggerSpeed - tCheck < 0.3 ) { triggerB.userInteractionEnabled = NO; }
    
    float perksOff = 0;
    
    if ( k.closeQuarters == NO && [self HasPerkBeenSelected:@"close"] == NO ) {
        [upgradesPanel addSubview:[self CreatePerkButton:@"close" Frame:CGRectMake(perksOff, 140, 40, 40)]];
        perksOff += 49;
    }
    if ( k.longRange == NO && [self HasPerkBeenSelected:@"range"] == NO ) {
        [upgradesPanel addSubview:[self CreatePerkButton:@"range" Frame:CGRectMake(perksOff, 140, 40, 40)]];
        perksOff += 49;
    }
    if ( k.extraAmmo == NO && [self HasPerkBeenSelected:@"ammo"] == NO ) {
        [upgradesPanel addSubview:[self CreatePerkButton:@"ammo" Frame:CGRectMake(perksOff, 140, 40, 40)]];
        perksOff += 49;
    }
    
    [self ShowUndoButton];
}

- (void) Undo {
    NSMutableArray *uCheck;
    if ( currentKid == 0 ) { uCheck = upgrades1; }
    else if ( currentKid == 1 ) { uCheck = upgrades2; }
    else { uCheck = upgrades3; }
    [uCheck removeObjectAtIndex:[uCheck count]-1];
    
    [self ShowUpgradePanel];
}

- (void) Done {
    // Save character data
    NSMutableArray *characters = [[NSMutableArray alloc] init];
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filesPath = [applicationDocumentsDir stringByAppendingPathComponent:@"characters.plist"];
    NSMutableDictionary *charactersDict = [NSMutableDictionary dictionaryWithContentsOfFile:filesPath];
    characters = [charactersDict objectForKey:@"Characters"];
    
    for ( Kid *k in kids ) {
        for ( NSMutableDictionary *chr in characters ) {
            if ( [k.name isEqualToString:[chr objectForKey:@"name"]] ) {
                currentKid = [kids indexOfObject:k];
                [chr setObject:[NSString stringWithFormat:@"%.1f",k.speed+[self CheckPoints:@"speed"]] forKey:@"speed"];
                [chr setObject:[NSString stringWithFormat:@"%.1f",k.reloadSpeed-[self CheckPoints:@"reload"]] forKey:@"reloadSpeed"];
                [chr setObject:[NSString stringWithFormat:@"%.1f",k.triggerSpeed-[self CheckPoints:@"trigger"]] forKey:@"triggerSpeed"];
                
                [chr setObject:[self AddNewPerksForSave:[chr objectForKey:@"skills"]] forKey:@"skills"];
                
                [chr setObject:[NSString stringWithFormat:@"%d",[self CanAfford]] forKey:@"upPoints"];
            }
        }
    }
    [charactersDict setObject:characters forKey:@"Characters"];
    [charactersDict writeToFile:filesPath atomically:YES];
    [parent performSelector:@selector(LevelFinishedPointsDone)];
}

- (float) CheckPoints:(NSString *)_type {
    NSMutableArray *uCheck;
    if ( currentKid == 0 ) { uCheck = upgrades1; }
    else if ( currentKid == 1 ) { uCheck = upgrades2; }
    else { uCheck = upgrades3; }
    
    float val = 0;
    
    for ( NSString *u in uCheck ) {
        if ( [_type isEqualToString:u] ) {
            val += .2;
        }
    }
    return val;
}

- (int) CanAfford {
    Kid *k = [kids objectAtIndex:currentKid];
    int base = k.kills/(int)(zombieCount*.1);
    base += k.upPoints;
    
    NSMutableArray *uCheck;
    if ( currentKid == 0 ) { uCheck = upgrades1; }
    else if ( currentKid == 1 ) { uCheck = upgrades2; }
    else { uCheck = upgrades3; }
        
    for ( NSString *u in uCheck ) {
        if ( [u isEqualToString:@"speed"] || [u isEqualToString:@"trigger"] || [u isEqualToString:@"reload"] ) {
            base -= 1;
        }
        if ( [u isEqualToString:@"close"] || [u isEqualToString:@"range"] || [u isEqualToString:@"ammo"] ) {
            base -= 3;
        }
    }
    return base;
}

- (UIButton*) CreatePerkButton:(NSString *)_type Frame:(CGRect)_rect {
    UIButton *perkButton = [[UIButton alloc] initWithFrame:_rect];
    [perkButton.titleLabel setText:_type];
    [perkButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"perk%@.png",_type]] forState:UIControlStateNormal];
    perkButton.tag = 3;
    [perkButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PerkStatSelected:)]];
    return perkButton;
}
- (UILabel*) CreateButtonLabel:(CGRect)_frame Color:(UIColor *)_color Text:(NSString *)_text {
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(_frame.origin.x+29, _frame.origin.y-1, 28, 20)];
    buttonLabel.backgroundColor = [UIColor clearColor]; buttonLabel.text = _text;
    buttonLabel.textColor = _color;
    [buttonLabel setTextAlignment:NSTextAlignmentCenter];
    [buttonLabel setFont:[UIFont fontWithName:@"Georgia" size:9.0f]];
    return buttonLabel;
}

- (void) ShowUndoButton {
    NSMutableArray *uCheck;
    if ( currentKid == 0 ) { uCheck = upgrades1; }
    else if ( currentKid == 1 ) { uCheck = upgrades2; }
    else { uCheck = upgrades3; }
    
    undoButton.userInteractionEnabled = NO;
    if ( [uCheck count] > 0 ) {
        undoButton.userInteractionEnabled = YES;
    }
}

- (BOOL) HasPerkBeenSelected:(NSString *)_perk {
    NSMutableArray *uCheck;
    if ( currentKid == 0 ) { uCheck = upgrades1; }
    else if ( currentKid == 1 ) { uCheck = upgrades2; }
    else { uCheck = upgrades3; }
    
    BOOL exists = NO;

    for ( NSString *p in uCheck ) {
        if ( [p isEqualToString:_perk] ) { exists = YES; }
    }

    return exists;
}

- (NSMutableArray*) AddNewPerksForSave:(NSMutableArray *)_skills {
    if ( [self HasPerkBeenSelected:@"close"] == YES ) {
        [_skills addObject:@"close"];
    }
    if ( [self HasPerkBeenSelected:@"range"] == YES ) {
        [_skills addObject:@"range"];
    }
    if ( [self HasPerkBeenSelected:@"ammo"] == YES ) {
        [_skills addObject:@"ammo"];
    }
    
    return _skills;
}

@end
