//
//  COJAppDelegate.m
//  Soundee
//
//  Created by Johannes Wärn on 05/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <SoundCloudAPI/SCAPI.h>
#import "SPMediaKeyTap.h"

#import "COJAppDelegate.h"
#import "COJSoundCloudKeys.h"
#import "COJMainWindowController.h"

@implementation COJAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                       andSelector:@selector(handleURLEvent:withReplyEvent:)
                                                     forEventClass:kInternetEventClass
                                                        andEventID:kAEGetURL];
    
    [SCSoundCloud setClientID:[COJSoundCloudKeys clientID]
                       secret:[COJSoundCloudKeys secret]
                  redirectURL:[NSURL URLWithString:@"soundee://oauth2"]];
    
    if (![SCSoundCloud account]) {
        [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
            [[NSWorkspace sharedWorkspace] openURL:preparedURL];
        }];
    }
    
    _mainWindowController = [[COJMainWindowController alloc] initWithWindowNibName:@"COJMainWindow"];
    [_mainWindowController showWindow:self];
    
    keyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];
	if([SPMediaKeyTap usesGlobalMediaKeyTap]) {
		[keyTap startWatchingMediaKeys];
    } else {
		NSLog(@"Media key monitoring disabled");
    }
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event
        withReplyEvent:(NSAppleEventDescriptor*)replyEvent;
{
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    [SCSoundCloud handleRedirectURL:[NSURL URLWithString:url]];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (IBAction)togglePlaying:(id)sender {
    [_mainWindowController togglePlaying:sender];
}
- (IBAction)next:(id)sender {
    [_mainWindowController next:sender];
}
- (IBAction)previous:(id)sender {
    [_mainWindowController previous:sender];
}

#pragma mark SPMediaKeyTapDelegate
-(void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event;
{
	assert([event type] == NSSystemDefined && [event subtype] == SPSystemDefinedEventMediaKeys);
    
	int keyCode = (([event data1] & 0xFFFF0000) >> 16);
	int keyFlags = ([event data1] & 0x0000FFFF);
	int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
//	int keyRepeat = (keyFlags & 0x1);
    
	if (keyState == 1 && _mainWindowController != NULL) {
		switch (keyCode) {
			case NX_KEYTYPE_PLAY:
                [self togglePlaying:event];
				return;
				
			case NX_KEYTYPE_FAST:
                [self next:event];
                return;
				
			case NX_KEYTYPE_REWIND:
                [self previous:event];
                return;
		}
	}
}


@end
