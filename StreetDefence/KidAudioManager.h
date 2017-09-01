//
//  KidAudioManager.h
//  StreetDefence
//
//  Created by Freddie on 17/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface KidAudioManager : NSObject {
    NSURL *shot, *clip, *walk, *counter;
}

@property (nonatomic, strong) AVAudioPlayer *aVPlayer;

- (void) InitSounds;
- (void) PlaySound:(NSURL*)_soundFile;
- (void) PlayShot;
- (void) PlayClip;
- (void) PlayWalk;
- (void) PlayCounter;

@end
