//
//  COJArtistTableCellView.m
//  Soundee
//
//  Created by Johannes Wärn on 08/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import "COJArtistTableCellView.h"
#import "COJImageView.h"

@implementation COJArtistTableCellView

- (void)setArtist:(NSDictionary *)artist
{
    NSString *userName = [artist objectForKey:@"username"];
    NSString *fullName = [artist objectForKey:@"full_name"];
    long tracks = [[artist objectForKey:@"track_count"] longValue];
    long followers = [[artist objectForKey:@"followers_count"] longValue];
    NSString *tracksAndFollowers = [NSString stringWithFormat:@"%li tracks, %li followers", tracks, followers];
    NSString *URLString = [artist objectForKey:@"avatar_url"];
    NSURL *imageURL;
    if ([URLString isKindOfClass:[NSString class]]) {
        imageURL = [NSURL URLWithString:URLString];
    }
    
    if (userName) {
        [_userName setStringValue:userName];
    } else {
        [_userName setStringValue:@""];
    }
    if (fullName) {
        [_fullName setStringValue:fullName];
    } else {
        [_fullName setStringValue:@""];
    }
    if (tracksAndFollowers) {
        [_tracksAndFollowers setStringValue:tracksAndFollowers];
    } else {
        [_tracksAndFollowers setStringValue:@""];
    }
    if (imageURL) {
        [_avatarImageView setImageWithURL:imageURL];
    } else {
        [_avatarImageView setImage:nil];
    }
}


@end
