//
//  COJSoundCloudUrlHelper.h
//  Soundee
//
//  Created by Johannes Wärn on 06/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COJSoundCloudUrlHelper : NSObject

+ (NSURL *)urlForSearchingString:(NSString *)string;
+ (NSURL *)urlForStream;
+ (NSURL *)urlForFollowing;
+ (NSURL *)urlForFavourites;
+ (NSURL *)urlFromStringWithClientIDAndJSON:(NSString *)string;
+ (NSURL *)trackURLFromURLString:(NSString *)string;

@end
