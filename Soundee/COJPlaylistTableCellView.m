//
//  COJPlaylistTableCellView.m
//  Soundee
//
//  Created by Johannes Wärn on 08/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import "COJPlaylistTableCellView.h"
#import "COJImageView.h"

@implementation COJPlaylistTableCellView

- (void)setPlaylist:(NSDictionary *)playlist
{
    NSString *title = [playlist objectForKey:@"title"];
    NSDictionary *artist = [playlist objectForKey:@"user"];
    NSString *artistName = [NSString stringWithFormat:@"by %@", [artist objectForKey:@"username"]];
    long tracksCount = [[playlist objectForKey:@"track_count"] longValue];
    NSString *tracks = [NSString stringWithFormat:@"%li tracks", tracksCount];
    NSString *URLString = [playlist objectForKey:@"artwork_url"];
    NSURL *imageURL;
    if ([URLString isKindOfClass:[NSString class]]) {
        imageURL = [NSURL URLWithString:URLString];
    } else {
        NSString *URLString = [artist objectForKey:@"avatar_url"];
        if ([URLString isKindOfClass:[NSString class]]) {
            imageURL = [NSURL URLWithString:URLString];
        }
    }
    
    if (title) {
        [_title setStringValue:title];
    } else {
        [_title setStringValue:@""];
    }
    if (artistName) {
        [_artistName setStringValue:artistName];
    } else {
        [_artistName setStringValue:@""];
    }
    if (tracks) {
        [_tracks setStringValue:tracks];
    } else {
        [_tracks setStringValue:@""];
    }
    if (imageURL) {
        [_artworkImageView setImageWithURL:imageURL];
    } else {
        [_artworkImageView setImage:nil];
    }
}

@end
