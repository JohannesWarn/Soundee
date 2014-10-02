//
//  COJGroupTableCellView.h
//  Soundee
//
//  Created by Johannes Wärn on 02/10/14.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class COJImageView;

@interface COJGroupTableCellView : NSTableCellView

- (void)setGroup:(NSDictionary *)group;

@property (weak) IBOutlet COJImageView *artworkImageView;
@property (weak) IBOutlet NSTextField *title;
@property (weak) IBOutlet NSTextField *creatorName;
@property (weak) IBOutlet NSTextField *description;

@end