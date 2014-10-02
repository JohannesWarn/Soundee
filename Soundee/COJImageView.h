//
//  COJImageView.h
//  Soundee
//
//  Created by Johannes Wärn on 06/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COJImageView : NSImageView
{
    NSURL *_url;
}

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(NSImage *)placeholderImage;
- (void)cancelImageDownload;

@property NSMutableData *activeDownload;
@property NSURLConnection *imageConnection;

@end