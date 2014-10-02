//
//  COJGroupTableCellView.m
//  Soundee
//
//  Created by Johannes Wärn on 02/10/14.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import "COJGroupTableCellView.h"
#import "COJImageView.h"

@implementation COJGroupTableCellView

- (void)setGroup:(NSDictionary *)group
{
    NSString *title = [group objectForKey:@"name"];
    
    NSString *description = [group objectForKey:@"short_description"];
    
    NSDictionary *creator = [group objectForKey:@"creator"];
    NSString *creatorName = [creator objectForKey:@"username"];
    
    NSString *URLString = [group objectForKey:@"artwork_url"];
    NSURL *imageURL;
    if ([URLString isKindOfClass:[NSString class]]) {
        imageURL = [NSURL URLWithString:URLString];
    } else {
        NSString *URLString = [creator objectForKey:@"avatar_url"];
        if ([URLString isKindOfClass:[NSString class]]) {
            imageURL = [NSURL URLWithString:URLString];
        }
    }
    
    if (title) {
        [_title setStringValue:title];
    } else {
        [_title setStringValue:@""];
    }
    if (creatorName) {
        [_creatorName setStringValue:[NSString stringWithFormat:@"by %@", creatorName]];
    } else {
        [_creatorName setStringValue:@""];
    }
    if (description) {
        [_description setStringValue:description];
    } else {
        [_description setStringValue:@""];
    }
    if (imageURL) {
        [_artworkImageView setImageWithURL:imageURL];
    } else {
        [_artworkImageView setImage:nil];
    }
}

@end