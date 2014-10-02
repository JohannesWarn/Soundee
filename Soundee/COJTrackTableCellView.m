//
//  COJTrackTableCellView.m
//  Soundee
//
//  Created by Johannes Wärn on 06/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import "COJTrackTableCellView.h"
#import "COJImageView.h"

@implementation COJTrackTableCellView

- (void)setTrack:(NSDictionary *)track
{
    NSString *title = [track objectForKey:@"title"];
    NSDictionary *artist = [track objectForKey:@"user"];
    NSString *artistName = [artist objectForKey:@"username"];
    NSString *URLString = [track objectForKey:@"artwork_url"];
    NSURL *imageURL;
    if ([URLString isKindOfClass:[NSString class]]) {
        imageURL = [NSURL URLWithString:URLString];
    } else {
        NSString *URLString = [artist objectForKey:@"avatar_url"];
        if ([URLString isKindOfClass:[NSString class]]) {
            imageURL = [NSURL URLWithString:URLString];
        }
    }
    
    if (title) {
        [_trackTitle setStringValue:title];
    } else {
        [_trackTitle setStringValue:@""];
    }
    if (artistName) {
        [_artistName setStringValue:artistName];
    } else {
        [_artistName setStringValue:@""];
    }
    if (imageURL) {
        [_trackImageView setImageWithURL:imageURL];
    } else {
        [_trackImageView setImage:nil];
    }
    
    [self setIsPlaying:NO];
    [self setIsCurrent:NO];
}

- (void)setIsPlaying:(BOOL)playing
{
    _playing = playing;
    [self updateIndicator];
}
- (void)setIsCurrent:(BOOL)current
{
    _current = current;
    [self updateIndicator];
}
- (void)updateIndicator
{
    if (_current) {
        if (_playing) {
            [_playingIndicator setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
        } else {
            [_playingIndicator setImage:[NSImage imageNamed:@"NSStatusPartiallyAvailable"]];
        }
    } else {
        [_playingIndicator setImage:nil];
    }
}

@end
