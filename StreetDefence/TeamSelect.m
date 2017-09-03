//
//  TeamSelect.m
//  StreetDefence
//
//  Created by Freddie on 11/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "TeamSelect.h"
#import "CharacterIcon.h"

@implementation TeamSelect

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithFrame:(CGRect)frame Parent:(NSObject *)_parent {
    if ( self = [super initWithFrame:frame] ) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        parent = _parent;
        
        console = [[UIView alloc] initWithFrame:CGRectMake(20, 320, frame.size.width-40, 280)];
        console.backgroundColor = [UIColor clearColor];
        [self addSubview:console];
        
        amountSelected = 0;
        [self initChars];
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, console.frame.size.width, console.frame.size.height)];
        bg.image = [UIImage imageNamed:@"teamSelectConsole.png"];
        [console addSubview:bg];
        
        for ( int i = 0; i < [characters count]; i++ ) {
            float heighty = i-(i%3);
            if ( heighty < 0 ) { heighty = 0; }
            CharacterIcon *c = [[CharacterIcon alloc] initWithFrame:CGRectMake((i%3)*60+19, heighty*20+19, 40, 40) KidPic:[NSString stringWithFormat:@"%@Port.png",[[characters objectAtIndex:i] objectForKey:@"name"]]];
            c.tag = i; [console addSubview:c];
            [c addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharacterTouched:)]];
        }
        
        highlight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        highlight.backgroundColor = [UIColor greenColor]; highlight.alpha = 0.5;
        [console addSubview:highlight]; highlight.hidden = YES;
        
        detailView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-100, 0, 100, 280)];
        detailView.backgroundColor = [UIColor clearColor];
        [console addSubview:detailView];
        
        teamView = [[UIView alloc] initWithFrame:CGRectMake(34, 213, 250, 50)];
        teamView.backgroundColor = [UIColor clearColor]; [console addSubview:teamView];
        
        SDLogo *sdlogo = [[SDLogo alloc] initWithFrame:CGRectMake(-14, 100, 30, 30)];
        [detailView addSubview:sdlogo];
        
        picksSD = [[SDLogo alloc] initWithFrame:CGRectMake(154, 226, 30, 30)];
        [console addSubview:picksSD];
        
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(console.frame.size.width-40, console.frame.size.height-34, 25, 25)];
        [cancel setImage:[UIImage imageNamed:@"quitButton.png"] forState:UIControlStateNormal];
        [cancel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Cancel)]];
        [console addSubview:cancel];
        
        /*UIView *picks = [[UIView alloc] initWithFrame:CGRectMake(10, 190, 320, 80)];
        picks.backgroundColor = [UIColor clearColor];
        [console addSubview:picks];*/
        
        [self AddDescBox];
        
        confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(cancel.frame.origin.x-40, cancel.frame.origin.y, 25, 25)];
        [confirmButton setImage:[UIImage imageNamed:@"confirmGreen.png"] forState:UIControlStateNormal];
        [confirmButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Done)]];
        [console addSubview:confirmButton];
        confirmButton.hidden = NO;
        
        [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            console.frame = CGRectMake(20, 20, console.frame.size.width, console.frame.size.height);
        } completion:^(BOOL finished){  }];
    }
    return self;
}

- (void) initChars {
    characters = [[NSMutableArray alloc] init];
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filesPath = [applicationDocumentsDir stringByAppendingPathComponent:@"characters.plist"];
    NSMutableDictionary *charactersDict = [NSMutableDictionary dictionaryWithContentsOfFile:filesPath];
    characters = [charactersDict objectForKey:@"Characters"];
}

- (void) CharacterTouched:(UITapGestureRecognizer *)_selected {
    //show stats
    highlight.center = _selected.view.center;
    highlight.hidden = NO;
    
    [detailView removeFromSuperview];
    detailView = [[UIView alloc] initWithFrame:CGRectMake(console.frame.size.width-102, 0, 100, 230)];
    detailView.backgroundColor = [UIColor clearColor];
    [console addSubview:detailView];
    
    NSMutableDictionary *charDat = [characters objectAtIndex:_selected.view.tag];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 86, 26)];
    name.font = [UIFont fontWithName:@"Stroke" size:19.0f];
    name.textColor = [UIColor whiteColor];
    [name setTextAlignment:NSTextAlignmentCenter];
    name.backgroundColor = [UIColor clearColor];
    name.text = [charDat objectForKey:@"name"];
    [detailView addSubview:name];
    
    UILabel *speed = [[UILabel alloc] initWithFrame:CGRectMake(8, 108, 90, 20)];
    speed.backgroundColor = [UIColor clearColor];
    speed.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    speed.font = [UIFont fontWithName:@"Georgia" size:10.0f];
    speed.text = [NSString stringWithFormat:@"Speed: %@",[charDat objectForKey:@"speed"]];
    [detailView addSubview:speed];
    
    UILabel *trigger = [[UILabel alloc] initWithFrame:CGRectMake(8, 120, 90, 20)];
    trigger.backgroundColor = [UIColor clearColor];
    trigger.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    trigger.font = [UIFont fontWithName:@"Georgia" size:10.0f];
    trigger.text = [NSString stringWithFormat:@"Trigger: %@",[charDat objectForKey:@"triggerSpeed"]];
    [detailView addSubview:trigger];
    
    UILabel *reload = [[UILabel alloc] initWithFrame:CGRectMake(8, 132, 90, 20)];
    reload.backgroundColor = [UIColor clearColor];
    reload.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    reload.font = [UIFont fontWithName:@"Georgia" size:10.0f];
    reload.text = [NSString stringWithFormat:@"Reload: %@",[charDat objectForKey:@"reloadSpeed"]];
    [detailView addSubview:reload];
    
    UILabel *energy = [[UILabel alloc] initWithFrame:CGRectMake(8, 144, 80, 20)];
    energy.backgroundColor = [UIColor clearColor];
    energy.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    energy.font = [UIFont fontWithName:@"Georgia" size:10.0f];
    //energy.text = [NSString stringWithFormat:@"energy: %@",[charDat objectForKey:@"energy"]];
    energy.text = @"Special abilities:";
    [detailView addSubview:energy];
    
    UIView *skills = [[UIView alloc] initWithFrame:CGRectMake(0, 165, 0, 26)];
    skills.backgroundColor = [UIColor clearColor];
    [detailView addSubview:skills];
    
    for ( NSString *skill in [charDat objectForKey:@"skills"] ) {
        UIImageView *sk = [[UIImageView alloc] initWithFrame:CGRectMake(skills.frame.size.width, 0, 26, 26)];
        sk.image = [UIImage imageNamed:[NSString stringWithFormat:@"perk%@.png",skill]];
        [skills addSubview:sk];
        
        skills.frame = CGRectMake(0, skills.frame.origin.y, skills.frame.size.width+28, 26);
    }
    skills.center = CGPointMake(detailView.frame.size.width/2-7, skills.center.y);
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(7, 18, 70, 70)];
    pic.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Port.png",[charDat objectForKey:@"name"]]];
    [detailView addSubview:pic];
    
    UIButton *pick = [[UIButton alloc] initWithFrame:CGRectMake(8, 196, 70, 30)];
    pick.tag = _selected.view.tag;
    [pick setImage:[UIImage imageNamed:@"selectCharButton.png"] forState:UIControlStateNormal];
    [pick addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CharacterSelected:)]];
    [detailView addSubview:pick];
}
- (void) CharacterSelected:(UITapGestureRecognizer *)_selected {
    
    [picksSD removeFromSuperview];
    
    if ( amountSelected == 0 ) {
        amountSelected++;
        pick1 = _selected.view.tag;
        [self AddCharToPicks:0 ImageName:[NSString stringWithFormat:@"%@Port.png",[[characters objectAtIndex:pick1] objectForKey:@"name"]] Ident:pick1];
    }
    else if ( amountSelected == 1 ) {
        if ( pick1 != _selected.view.tag ) {
            amountSelected++;
            pick2 = _selected.view.tag;
            [self AddCharToPicks:100 ImageName:[NSString stringWithFormat:@"%@Port.png",[[characters objectAtIndex:pick2] objectForKey:@"name"]] Ident:pick2];
        }
    }
    else if ( amountSelected == 2 ) {
        if ( pick1 != _selected.view.tag && pick2 != _selected.view.tag ) {
            amountSelected++;
            pick3 = _selected.view.tag;
            [self AddCharToPicks:200 ImageName:[NSString stringWithFormat:@"%@Port.png",[[characters objectAtIndex:pick3] objectForKey:@"name"]] Ident:pick3];
        }
    }
    
    if ( amountSelected == 3 ) { confirmButton.hidden = NO; }
}

- (void) Cancel {
    [UIView animateWithDuration:0.3 animations:^(void){ self.alpha = 0; }];
}
- (void) Done {
    if ( amountSelected == 3 ) {
    
        NSMutableArray *team = [[NSMutableArray alloc] init];
        [team addObject:[NSNumber numberWithInt:pick1]];
        [team addObject:[NSNumber numberWithInt:pick2]];
        [team addObject:[NSNumber numberWithInt:pick3]];
    
        [parent performSelector:@selector(UpdateTeam:) withObject:team];
    }
}

- (void) AddCharToPicks:(float)_xPoint ImageName:(NSString *)_image Ident:(int)_iTag {
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(_xPoint, 0, 50, 50)];
    pic.image = [UIImage imageNamed:_image];
    [teamView addSubview:pic];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    cancel.center = pic.center; cancel.tag = _iTag;
    [cancel setImage:[UIImage imageNamed:@"removeCharacter.png"] forState:UIControlStateNormal];
    [cancel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RemoveCharacter:)]];
    [teamView addSubview:cancel];
    
    [console bringSubviewToFront:teamView];
}

- (void) AddDescBox {
    UIView *tipsBox = [[UIView alloc] initWithFrame:CGRectMake(192, 10, 134, 174)];
    tipsBox.backgroundColor = [UIColor clearColor];
    [console addSubview:tipsBox];
    
    UILabel *tip1 = [[UILabel alloc] initWithFrame:CGRectMake(6, 10, 110, 40)];
    tip1.backgroundColor = [UIColor clearColor]; tip1.font = [UIFont fontWithName:@"Courier" size:8.0f];
    tip1.textColor = [UIColor greenColor]; tip1.numberOfLines = 4;
    tip1.text = @"- Pick a variety of kids to give yourself the best chance of survival.";
    [tipsBox addSubview:tip1];
    
    UILabel *tip2 = [[UILabel alloc] initWithFrame:CGRectMake(6, 50, 110, 50)];
    tip2.backgroundColor = [UIColor clearColor]; tip2.font = [UIFont fontWithName:@"Courier" size:8.0f];
    tip2.textColor = [UIColor greenColor]; tip2.numberOfLines = 5;
    tip2.text = @"- Once your kids die, they ain't coming back. Don't use all your best kids unless you must.";
    [tipsBox addSubview:tip2];
    
    UILabel *tip3 = [[UILabel alloc] initWithFrame:CGRectMake(6, 100, 104, 64)];
    tip3.backgroundColor = [UIColor clearColor]; tip3.font = [UIFont fontWithName:@"Courier" size:8.0f];
    tip3.textColor = [UIColor greenColor]; tip3.numberOfLines = 6;
    tip3.text = @"- Trigger speed denotes the time taken to shoot, reload speed is the time taken to reload (15 shots per clip).";
    [tipsBox addSubview:tip3];
}

- (void) RemoveCharacter:(UITapGestureRecognizer *)_selected {
    if ( _selected.view.tag == pick1 ) {
        pick1 = pick2; pick2 = pick3; pick3 = -1;
    }
    else if ( _selected.view.tag == pick2 ) {
        pick2 = pick3; pick3 = -1;
    }
    else {
        pick3 = -1;
    }
    amountSelected--;
    
    [teamView removeFromSuperview];
    teamView = [[UIView alloc] initWithFrame:CGRectMake(34, 213, 250, 50)];
    teamView.backgroundColor = [UIColor clearColor]; [console addSubview:teamView];
    
    if ( pick1 != -1 ) {
        [self AddCharToPicks:0 ImageName:[NSString stringWithFormat:@"%@Port.png",[[characters objectAtIndex:pick1] objectForKey:@"name"]] Ident:pick1];
    }
    if ( pick2 != -1 ) {
            [self AddCharToPicks:100 ImageName:[NSString stringWithFormat:@"%@Port.png",[[characters objectAtIndex:pick2] objectForKey:@"name"]] Ident:pick2];
    }
    if ( pick3 != -1 ) {
            [self AddCharToPicks:200 ImageName:[NSString stringWithFormat:@"%@Port.png",[[characters objectAtIndex:pick3] objectForKey:@"name"]] Ident:pick3];
    }    
}

@end
