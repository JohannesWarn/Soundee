//
//  COJAudioPlayer.m
//  Soundee
//
//  Created by Johannes Wärn on 06/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <SoundCloudAPI/SCAPI.h>

#import "COJAudioPlayer.h"
#import "COJSoundCloudUrlHelper.h"

@implementation COJAudioPlayer

- (void)playTrack:(NSDictionary *)track
{
    [self playTrack:track inList:nil];
}

- (void)playTrack:(NSDictionary *)track inList:(NSArray *)list
{
    [self pause];
    _player = nil;
    
    if (self.delegate) {
        [self.delegate audioPlayerWillChangeTrack];
    }
    
    _currentTrack = track;
    _trackList = list;
    _currentTrackNumber = [_trackList indexOfObject:track];
    
    [self updateCurrentTrackCurrentTime];
    if (self.delegate) {
        [self.delegate audioPlayerDidChangeTrack];
    }
    
    if (track == nil) return;
    
    if (_nextPlayer && [_preparedTrack objectForKey:@"id"] == [track objectForKey:@"id"]) {
        _player = _nextPlayer;
        [self updateCurrentTrackDuration];
        [self play];
        [self prepareNextTrack];
        return;
    }
    
    // Prepare the SoundCloud request
    NSURL *streamURL = [COJSoundCloudUrlHelper trackURLFromURLString:[track objectForKey:@"stream_url"]];
    
    void (^responseHandler)(NSURLResponse *response, NSData *data, NSError *error) = ^(NSURLResponse *response, NSData *data, NSError *error) {
        _currentRequestID = nil;
        
        NSError *playerError;
        _player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
        [_player setDelegate:self];
        [self updateCurrentTrackDuration];
        [self play];
        [self prepareNextTrack];
        if (playerError) {
            NSLog(@"error: %@", playerError);
        }
    };
    
    if (_currentRequestID) {
        [SCRequest cancelRequest:_currentRequestID];
        _currentRequestID = nil;
    }
    _currentRequestID = [SCRequest performMethod:SCRequestMethodGET
                                      onResource:streamURL
                                 usingParameters:nil
                                     withAccount:nil
                          sendingProgressHandler:nil
                                 responseHandler:responseHandler];
}

- (void)prepareNextTrack
{
    _nextPlayer = nil;
    
    NSDictionary *nextTrack;
    NSInteger i = 1;
    while (_currentTrackNumber+i < _trackList.count && ![[nextTrack objectForKey:@"kind"] isEqualToString:@"track"]) {
        nextTrack = [_trackList objectAtIndex:_currentTrackNumber+i];
        i++;
    }
    if (!nextTrack) {
        return;
    }
    
    _preparedTrack = nextTrack;
    
    // Prepare the SoundCloud request
    NSURL *streamURL = [COJSoundCloudUrlHelper trackURLFromURLString:[nextTrack objectForKey:@"stream_url"]];
    
    void (^responseHandler)(NSURLResponse *response, NSData *data, NSError *error) = ^(NSURLResponse *response, NSData *data, NSError *error) {
        _currentRequestID = nil;
        
        NSError *playerError;
        _nextPlayer = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
        [_nextPlayer prepareToPlay];
        if (playerError) {
            NSLog(@"error: %@", playerError);
        }
    };
    
    if (_currentRequestID) {
        [SCRequest cancelRequest:_currentRequestID];
        _currentRequestID = nil;
    }
    _currentRequestID = [SCRequest performMethod:SCRequestMethodGET
                                      onResource:streamURL
                                 usingParameters:nil
                                     withAccount:nil
                          sendingProgressHandler:nil
                                 responseHandler:responseHandler];
}

#pragma mark Play Next/Previous

- (void)playNextTrack
{
    NSDictionary *nextTrack;
    NSInteger i = 1;
    while (_currentTrackNumber+i < _trackList.count && ![[nextTrack objectForKey:@"kind"] isEqualToString:@"track"]) {
        nextTrack = [_trackList objectAtIndex:_currentTrackNumber+i];
        i++;
    }
    
    if ([[nextTrack objectForKey:@"kind"] isEqualToString:@"track"]) {
        [self playTrack:nextTrack inList:_trackList];
    }
}

- (void)playPreviousTrack
{
    NSDictionary *previousTrack;
    NSInteger i = 1;
    while (_currentTrackNumber-i >= 0 && ![[previousTrack objectForKey:@"kind"] isEqualToString:@"track"]) {
        previousTrack = [_trackList objectAtIndex:_currentTrackNumber-i];
        i++;
    }
    
    if ([[previousTrack objectForKey:@"kind"] isEqualToString:@"track"]) {
        [self playTrack:previousTrack inList:_trackList];
    }
}

#pragma mark Update Delegate

- (void)updateCurrentTrackDuration
{
    [self.delegate audioPlayerDidChangeTrackDuration];
}

- (void)updateCurrentTrackCurrentTime
{
    [self.delegate audioPlayerDidChangeTrackCurrentTime];
}

#pragma Toggle Playing

- (void)togglePlaying
{
    if ([_player isPlaying]) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)play
{
    [_player play];
    
    [_currentTimeTimer invalidate];
    _currentTimeTimer = nil;
    _currentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1/60
                                                         target:self
                                                       selector:@selector(updateCurrentTrackCurrentTime)
                                                       userInfo:nil
                                                        repeats:YES];
    
    if (self.delegate) {
        [self.delegate audioPlayerDidChangePlayPause];
    }
}

- (void)pause
{
    [_player pause];
    
    [_currentTimeTimer invalidate];
    _currentTimeTimer = nil;
    
    if (self.delegate) {
        [self.delegate audioPlayerDidChangePlayPause];
    }
}

#pragma mark Status

- (BOOL)isPlaying
{
    return [_player isPlaying];
}

- (NSTimeInterval)duration
{
    return [_player duration];
}

- (NSTimeInterval)currentTime
{
    return [_player currentTime];
}

- (void)setCurrentTime:(NSTimeInterval)newTime
{
    [_player setCurrentTime:newTime];
}

#pragma mark AVAudioPLayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self playNextTrack];
}

@end
