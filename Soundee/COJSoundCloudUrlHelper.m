//
//  COJSoundCloudUrlHelper.m
//  Soundee
//
//  Created by Johannes Wärn on 06/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <SoundCloudAPI/SCAPI.h>

#import "COJSoundCloudUrlHelper.h"
#import "COJSoundCloudKeys.h"

@implementation COJSoundCloudUrlHelper

+ (NSURL *)urlForSearchingString:(NSString *)string
{
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    string = [NSString stringWithFormat:@"https://api.soundcloud.com/search/?q=%@&client_id=%@&format=json", string, [COJSoundCloudKeys clientID]];
    return [NSURL URLWithString:string];
}

+ (NSURL *)urlForStream
{
    NSString *urlString = @"https://api.soundcloud.com/me/activities";
    return [COJSoundCloudUrlHelper urlFromStringWithClientIDAndJSON:urlString];
}

+ (NSURL *)urlForFollowing
{
    NSString *urlString = @"https://api.soundcloud.com/me/followings";
    return [COJSoundCloudUrlHelper urlFromStringWithClientIDAndJSON:urlString];
}

+ (NSURL *)urlForFavourites
{
    NSString *urlString = @"https://api.soundcloud.com/me/favorites";
    return [COJSoundCloudUrlHelper urlFromStringWithClientIDAndJSON:urlString];
}

+ (NSURL *)urlFromStringWithClientIDAndJSON:(NSString *)string
{
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&format=json", string, [COJSoundCloudKeys clientID]];
    return [[NSURL alloc] initWithString:urlString];
}

+ (NSURL *)trackURLFromURLString:(NSString *)string
{
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", string, [COJSoundCloudKeys clientID]];
    return [[NSURL alloc] initWithString:urlString];
}

@end
