//
//  COJPlaylistTableCellView.h
//  Soundee
//
//  Created by Johannes Wärn on 08/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class COJImageView;

@interface COJPlaylistTableCellView : NSTableCellView

- (void)setPlaylist:(NSDictionary *)playlist;

@property (weak) IBOutlet COJImageView *artworkImageView;
@property (weak) IBOutlet NSTextField *title;
@property (weak) IBOutlet NSTextField *artistName;
@property (weak) IBOutlet NSTextField *tracks;

@end
