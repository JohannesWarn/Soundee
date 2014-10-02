//
//  COJImageView.m
//  Soundee
//
//  Created by Johannes Wärn on 06/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import "COJImageView.h"

@implementation COJImageView

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(NSImage *)placeholderImage
{
    NSImage *cachedImage = [COJImageView cachedImageForURL:url];
    if (cachedImage) {
        [self setImage:cachedImage];
        return;
    }
    
    _url = url;
    [self setImage:placeholderImage];
    
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.imageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)cancelImageDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark Caching

+ (NSCache *)sharedCache
{
    static NSCache *sharedCache = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedCache = [[NSCache alloc] init];
    });
    return sharedCache;
}
+ (NSImage *)cachedImageForURL:(NSURL *)url
{
    NSImage *image = [[COJImageView sharedCache] objectForKey:url];
    if (image) {
        return image;
    }
    return nil;
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.imageConnection = nil;
    self.activeDownload = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSImage *image = [[NSImage alloc] initWithData:self.activeDownload];
    if (image) {
        [self setImage:image];
        [[COJImageView sharedCache] setObject:image forKey:_url];
    }
    
    self.imageConnection = nil;
    self.activeDownload = nil;
}

@end