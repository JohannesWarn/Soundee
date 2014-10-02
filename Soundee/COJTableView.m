//
//  COJTableView.m
//  Soundee
//
//  Created by Johannes Wärn on 08/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import "COJTableView.h"

@implementation COJTableView

- (void)keyDown:(NSEvent *)theEvent
{
    if ([self.keysDelegate respondsToSelector:@selector(didRecieveKeyDown:)]) {
        if ([theEvent keyCode] == 36 || [theEvent keyCode] == 49) {
            [self.keysDelegate didRecieveKeyDown:theEvent];
            return;
        }
    }
    [super keyDown:theEvent];
}

@end
