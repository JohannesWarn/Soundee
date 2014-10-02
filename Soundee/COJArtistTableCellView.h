//
//  COJArtistTableCellView.h
//  Soundee
//
//  Created by Johannes Wärn on 08/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class COJImageView;

@interface COJArtistTableCellView : NSTableCellView

- (void)setArtist:(NSDictionary *)artist;

@property (weak) IBOutlet COJImageView *avatarImageView;
@property (weak) IBOutlet NSTextField *fullName;
@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSTextField *tracksAndFollowers;

@end
