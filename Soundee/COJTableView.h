//
//  COJTableView.h
//  Soundee
//
//  Created by Johannes Wärn on 08/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol COJKeysDelegate;

@interface COJTableView : NSTableView

@property id<COJKeysDelegate> keysDelegate;

@end

@protocol COJKeysDelegate <NSObject>
@optional
- (void)didRecieveKeyDown:(NSEvent *)theEvent;

@end