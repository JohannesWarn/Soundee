//
//  COJAudioPlayer.h
//  Soundee
//
//  Created by Johannes Wärn on 06/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol COJAudioPlayerDelegate;

@interface COJAudioPlayer : NSObject <AVAudioPlayerDelegate>
{
    AVAudioPlayer *_player;
    AVAudioPlayer *_nextPlayer;
    NSDictionary  *_preparedTrack;
    id             _currentRequestID;
    NSTimer       *_currentTimeTimer;
}

- (void)playTrack:(NSDictionary *)track;
- (void)playTrack:(NSDictionary *)track inList:(NSArray *)list;
- (void)playNextTrack;
- (void)playPreviousTrack;
- (void)togglePlaying;
- (void)play;
- (void)pause;
- (BOOL)isPlaying;
- (NSTimeInterval)duration;
- (NSTimeInterval)currentTime;
- (void)setCurrentTime:(NSTimeInterval)newTime;

@property id<COJAudioPlayerDelegate> delegate;
@property NSDictionary *currentTrack;
@property NSInteger currentTrackNumber;
@property NSArray *trackList;

@end

@protocol COJAudioPlayerDelegate <NSObject>
- (void)audioPlayerDidChangePlayPause;
- (void)audioPlayerWillChangeTrack;
- (void)audioPlayerDidChangeTrack;
- (void)audioPlayerDidChangeTrackDuration;
- (void)audioPlayerDidChangeTrackCurrentTime;
@end