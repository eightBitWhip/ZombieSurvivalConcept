//
//  KidsStatus.m
//  StreetDefence
//
//  Created by Freddie on 11/06/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "KidsStatus.h"

@implementation KidsStatus

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        bg.image = [UIImage imageNamed:@"aliveStatusBar.png"]; [self addSubview:bg];
        
        UIView *chars = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 0, 16)];
        
        NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filesPath = [applicationDocumentsDir stringByAppendingPathComponent:@"characters.plist"];
        NSMutableDictionary *myCharsDict = [NSMutableDictionary dictionaryWithContentsOfFile:filesPath];
        NSArray *myCharsArr = [myCharsDict objectForKey:@"Characters"];
            
        NSString *primPath = [[NSBundle mainBundle] bundlePath];
        NSString *path = [primPath stringByAppendingPathComponent:@"characters.plist"];
        NSMutableDictionary *charactersDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        NSArray *charsArr = [charactersDict objectForKey:@"Characters"];
        
        for ( int i = 0; i < [charsArr count]; i++ ) {
            UIImageView *charIm = [[UIImageView alloc] initWithFrame:CGRectMake(chars.frame.size.width, 0, 16, 16)];
            charIm.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Port.png",[[charsArr objectAtIndex:i] objectForKey:@"name"]]];
            [chars addSubview:charIm];
            
            bool dead = YES;
            
            for ( int j = 0; j < [myCharsArr count]; j++ ) {
                if ( [[[charsArr objectAtIndex:i] objectForKey:@"name"] isEqualToString:[[myCharsArr objectAtIndex:j] objectForKey:@"name"]] ) {
                    dead = NO;
                }
            }
            if ( dead == YES ) {
                UIView *deadView = [[UIView alloc] initWithFrame:charIm.frame];
                deadView.backgroundColor = [UIColor redColor]; deadView.alpha = 0.6;
                [chars addSubview:deadView];
            }
            
            chars.frame = CGRectMake(0, chars.frame.origin.y, chars.frame.size.width+19, chars.frame.size.height);
        }
        [self addSubview:chars];
        chars.center = CGPointMake(100, chars.center.y);
        
    }
    return self;
}

@end
