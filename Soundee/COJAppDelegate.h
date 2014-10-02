//
//  COJAppDelegate.h
//  Soundee
//
//  Created by Johannes Wärn on 05/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class COJMainWindowController;

@interface COJAppDelegate : NSObject <NSApplicationDelegate>
{
    COJMainWindowController *_mainWindowController;
    SPMediaKeyTap *keyTap;
}

@end
