//
//  COJLoginWindowController.m
//  Soundee
//
//  Created by Johannes Wärn on 09/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <SoundCloudAPI/SCAPI.h>

#import "COJLoginWindowController.h"

@implementation COJLoginWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.window makeKeyAndOrderFront:self];
    [_webView setResourceLoadDelegate:self];
}

- (NSURLRequest *)webView:(WebView *)sender
                 resource:(id)identifier
          willSendRequest:(NSURLRequest *)request
         redirectResponse:(NSURLResponse *)redirectResponse
           fromDataSource:(WebDataSource *)dataSource
{
    NSLog(@"changing login window URL to: %@", [request URL]);
    
    return request;
}

@end
