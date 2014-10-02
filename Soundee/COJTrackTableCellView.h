//
//  COJTrackTableCellView.h
//  Soundee
//
//  Created by Johannes Wärn on 06/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class COJImageView;

@interface COJTrackTableCellView : NSTableCellView
{
    BOOL _playing;
    BOOL _current;
}

- (void)setTrack:(NSDictionary *)track;
- (void)setIsPlaying:(BOOL)playing;
- (void)setIsCurrent:(BOOL)current;

@property (weak) IBOutlet COJImageView *trackImageView;
@property (weak) IBOutlet NSImageView *playingIndicator;
@property (weak) IBOutlet NSTextField *trackTitle;
@property (weak) IBOutlet NSTextField *artistName;

@end
