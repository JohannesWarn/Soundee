//
//  COJMainWindowController.h
//  Soundee
//
//  Created by Johannes Wärn on 05/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "COJAudioPlayer.h"
#import "COJTableView.h"

@interface COJMainWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate, COJAudioPlayerDelegate, COJKeysDelegate>

- (void)interactWithRow;
- (IBAction)togglePlaying:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)seekToTime:(id)sender;

@property (weak) IBOutlet COJTableView *tableView;

@property (weak) IBOutlet NSButton *playPauseButton;
@property (weak) IBOutlet NSSlider *currentTimeSlider;

@end
