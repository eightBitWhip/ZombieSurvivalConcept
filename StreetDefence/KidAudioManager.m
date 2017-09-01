//
//  KidAudioManager.m
//  StreetDefence
//
//  Created by Freddie on 17/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "KidAudioManager.h"

@implementation KidAudioManager

@synthesize aVPlayer;

- (id) init {
    if ( self = [super init] ) {
        [self InitSounds];
    }
    return self;
}

- (void) InitSounds {
    NSString *audioPathS = [NSString stringWithFormat:@"%@/audioShoot.mp3", [[NSBundle mainBundle] resourcePath]];
    shot = [NSURL fileURLWithPath:audioPathS];
    NSString *audioPathC = [NSString stringWithFormat:@"%@/audioReload.mp3", [[NSBundle mainBundle] resourcePath]];
    clip = [NSURL fileURLWithPath:audioPathC];
    NSString *audioPathW = [NSString stringWithFormat:@"%@/audioWalk.mp3", [[NSBundle mainBundle] resourcePath]];
    walk = [NSURL fileURLWithPath:audioPathW];
    NSString *audioPathCo = [NSString stringWithFormat:@"%@/audioCounter.mp3", [[NSBundle mainBundle] resourcePath]];
    counter = [NSURL fileURLWithPath:audioPathCo];
}

- (void) PlaySound:(NSURL *)_soundFile {
    //if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"muted"] intValue] == 0 ) {
        @try {
            NSError *error;
            aVPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:_soundFile error:&error];
            [aVPlayer prepareToPlay];
            [aVPlayer play];
            
            if ( error ) NSLog(@"%@",error);
        }
        @catch (NSException *e) {
            NSLog(@"%@", e);
        }
    //}
}
- (void) PlayShot {
    [self PlaySound:shot];
}
- (void) PlayClip {
    [self PlaySound:clip];
}
- (void) PlayWalk {
    [self PlaySound:walk];
}
- (void) PlayCounter {
    [self PlaySound:counter];
}

@end
