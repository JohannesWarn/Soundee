//
//  COJMainWindowController.m
//  Soundee
//
//  Created by Johannes Wärn on 05/05/2014.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <SoundCloudAPI/SCAPI.h>

#import "COJMainWindowController.h"
#import "COJNavigationStack.h"
#import "COJLoginWindowController.h"

#import "COJSoundCloudUrlHelper.h"

#import "COJTableView.h"
#import "COJTrackTableCellView.h"
#import "COJArtistTableCellView.h"
#import "COJPlaylistTableCellView.h"
#import "COJGroupTableCellView.h"
#import "COJImageView.h"

@implementation COJMainWindowController {
    COJAudioPlayer *_audioPlayer;
    COJNavigationStack *_navigationStack;
    COJLoginWindowController *_loginWindowController;
    id _currentRequestID;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _audioPlayer = [[COJAudioPlayer alloc] init];
        [_audioPlayer setDelegate:self];
        _navigationStack = [[COJNavigationStack alloc] init];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [_tableView setDoubleAction:@selector(interactWithRow)];
    [_tableView setKeysDelegate:self];
    
    [self navigateToStream];
}

#pragma mark Navigation

- (void)buildTableFromJSONData:(NSData *)JSONData
{
    [self removeCurrentlyPlayingIndicator];
    
    NSError *jsonError;
    NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&jsonError];
    
    NSArray *jsonArray;
    NSDictionary *jsonDictionary;
    
    if (!jsonError) {
        if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
            jsonDictionary = (NSDictionary *)jsonResponse;
            if ([[jsonDictionary objectForKey:@"collection"] isKindOfClass:[NSArray class]]) {
                jsonArray = (NSArray *)[jsonDictionary objectForKey:@"collection"];
            } else {
                jsonArray = nil;
            }
        } else if ([jsonResponse isKindOfClass:[NSArray class]]) {
            jsonArray = (NSArray *)jsonResponse;
        } else {
            jsonArray = @[];
        }
        [_navigationStack pushTableViewData:jsonArray];
        [_tableView reloadData];
        [_tableView scrollPoint:NSMakePoint(0, 0)];
        
        [self updateCurrentlyPlayingIndicator];
    } else {
        NSLog(@"JSON error: %@", jsonError.localizedDescription);
    }
}

- (void)requestURL:(NSURL *)url {
    void (^responseHandler)(NSURLResponse *response, NSData *data, NSError *error) = ^(NSURLResponse *response, NSData *data, NSError *error) {
        _currentRequestID = nil;
        if (!error) {
            [self buildTableFromJSONData:data];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    };
    
    if (_currentRequestID) {
        [SCRequest cancelRequest:_currentRequestID];
        _currentRequestID = nil;
    }
    _currentRequestID = [SCRequest performMethod:SCRequestMethodGET
                                      onResource:url
                                 usingParameters:nil
                                     withAccount:[SCSoundCloud account]
                          sendingProgressHandler:nil
                                 responseHandler:responseHandler];
}

- (void)navigateToURLString:(NSString *)URLString
{
    NSURL *navigationURL = [COJSoundCloudUrlHelper urlFromStringWithClientIDAndJSON:URLString];
    [self requestURL:navigationURL];
}

- (void)navigateToStream
{
    [_navigationStack popAll];
    [_tableView reloadData];
    
    NSURL *followingURL = [COJSoundCloudUrlHelper urlForStream];
    [self requestURL:followingURL];
}

- (void)navigateToFollowing
{
    [_navigationStack popAll];
    [_tableView reloadData];

    NSURL *followingURL = [COJSoundCloudUrlHelper urlForFollowing];
    [self requestURL:followingURL];
}

- (void)navigateToFavourites
{
    [_navigationStack popAll];
    [_tableView reloadData];
    
    NSURL *followingURL = [COJSoundCloudUrlHelper urlForFavourites];
    [self requestURL:followingURL];
}

- (void)searchWithString:(NSString *)searchString
{   
    [_navigationStack popAll];
    [_tableView reloadData];
    
    NSURL *searchURL = [COJSoundCloudUrlHelper urlForSearchingString:searchString];
    [self requestURL:searchURL];
}

#pragma mark Current Track

- (COJTrackTableCellView *)currentTrackTableCellView
{
    NSArray *currentTableViewData = [_navigationStack currentTableViewData];
    
    if (currentTableViewData == nil) {
        return nil;
    }
    
    NSUInteger index = [currentTableViewData indexOfObject:[_audioPlayer currentTrack]];
    
    if (index == NSNotFound) {
        NSDictionary *currentTrack = [_audioPlayer currentTrack];
        NSUInteger currentTrackID = [[currentTrack objectForKey:@"id"] unsignedIntegerValue];
        for (NSUInteger i = 0; i < currentTableViewData.count; i++) {
            NSDictionary *rowData = [currentTableViewData objectAtIndex:i];
            if ([rowData objectForKey:@"origin"]) {
                rowData = [rowData objectForKey:@"origin"];
            }
            
            NSUInteger trackAtIndexID = [[rowData objectForKey:@"id"] unsignedIntegerValue];
            if (trackAtIndexID == currentTrackID) {
                index = i;
                break;
            }
        }
    }
    
    if (index != NSNotFound) {
        NSView *cellView = [_tableView viewAtColumn:0 row:index makeIfNecessary:YES];
        if ([cellView isKindOfClass:[COJTrackTableCellView class]]) {
            COJTrackTableCellView *trackView = (COJTrackTableCellView *)cellView;
            return trackView;
        }
    }
    return nil;
}

- (void)removeCurrentlyPlayingIndicator
{
    COJTrackTableCellView *currentTrackView = [self currentTrackTableCellView];
    [currentTrackView setIsCurrent:NO];
    [currentTrackView setIsPlaying:NO];
}

- (void)updateCurrentlyPlayingIndicator
{
    COJTrackTableCellView *currentTrackView = [self currentTrackTableCellView];
    [currentTrackView setIsCurrent:YES];
    [currentTrackView setIsPlaying:[_audioPlayer isPlaying]];
}

#pragma mark Toolbar Actions

- (IBAction)showStream:(id)sender
{
    [self navigateToStream];
}

- (IBAction)showFollowing:(id)sender
{
    [self navigateToFollowing];
}

- (IBAction)showLikes:(id)sender
{
    [self navigateToFavourites];
}

- (IBAction)search:(id)sender
{
    NSString *searchString = [sender stringValue];
    if (searchString) {
        [self searchWithString:searchString];
    }
}

#pragma mark Navbar Actions

- (IBAction)back:(id)sender
{
    [_navigationStack popLast];
    [_tableView reloadData];
    [self updateCurrentlyPlayingIndicator];
}

#pragma mark Playback Actions
- (void)interactWithRow
{
    NSDictionary *rowData;
    NSInteger rowNumber;
    
    if (_tableView.clickedRow >= 0) {
        rowNumber = _tableView.clickedRow;
    } else if (_tableView.selectedRow >= 0) {
        rowNumber = _tableView.selectedRow;
    } else {
        return;
    }
    
    NSArray *currentTableViewData = [_navigationStack currentTableViewData];
    
    rowData = [currentTableViewData objectAtIndex:rowNumber];
    if ([rowData objectForKey:@"origin"]) {
        rowData = [rowData objectForKey:@"origin"];
    }
    
    if ([[rowData objectForKey:@"kind"] isEqualToString:@"track"]) {
        [_audioPlayer playTrack:rowData inList:currentTableViewData];
    } else if ([[rowData objectForKey:@"uri"] isKindOfClass:[NSString class]]) {
        [self navigateToURLString:[NSString stringWithFormat:@"%@/tracks", [rowData objectForKey:@"uri"]]];
    }
}
- (IBAction)togglePlaying:(id)sender {
    if ([_audioPlayer currentTrack]) {
        [_audioPlayer togglePlaying];
    } else {
        NSArray *currentTableViewData = [_navigationStack currentTableViewData];
        NSDictionary *firstTrack;
        NSInteger i = 1;
        while (i < currentTableViewData.count && ![[firstTrack objectForKey:@"kind"] isEqualToString:@"track"]) {
            firstTrack = [currentTableViewData objectAtIndex:i];
            i++;
        }
        [_audioPlayer playTrack:firstTrack inList:currentTableViewData];
    }
}
- (IBAction)next:(id)sender {
    [_audioPlayer playNextTrack];
}
- (IBAction)previous:(id)sender {
    [_audioPlayer playPreviousTrack];
}
- (IBAction)seekToTime:(id)sender {
    NSTimeInterval currentTime = [sender doubleValue];
    [_audioPlayer setCurrentTime:currentTime];
}

#pragma mark COJKeysDelegate
- (void)didRecieveKeyDown:(NSEvent *)theEvent
{
    if ([theEvent keyCode] == 36) {
        [self interactWithRow];
    } else if ([theEvent keyCode] == 49) {
        [self togglePlaying:_tableView];
    }
}

#pragma mark COJAudioPlayerDelegate
- (void)audioPlayerDidChangePlayPause
{
    if ([_audioPlayer isPlaying]) {
        [_playPauseButton setTitle:@"Pause"];
    } else {
        [_playPauseButton setTitle:@"Play"];
    }
    [self updateCurrentlyPlayingIndicator];
}
- (void)audioPlayerWillChangeTrack
{
    [self removeCurrentlyPlayingIndicator];
}
- (void)audioPlayerDidChangeTrack
{
    [self updateCurrentlyPlayingIndicator];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    NSDictionary *track = [_audioPlayer currentTrack];
    NSDictionary *artist = [track objectForKey:@"user"];
    notification.title = [track objectForKey:@"title"];
    notification.informativeText = [artist objectForKey:@"username"];
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}
- (void)audioPlayerDidChangeTrackDuration
{
    [_currentTimeSlider setMaxValue:[_audioPlayer duration]];
}
- (void)audioPlayerDidChangeTrackCurrentTime
{
    [_currentTimeSlider setDoubleValue:[_audioPlayer currentTime]];
}

#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[_navigationStack currentTableViewData] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSDictionary *rowData = [[_navigationStack currentTableViewData] objectAtIndex:row];
    
    if ([rowData objectForKey:@"origin"]) {
        rowData = [rowData objectForKey:@"origin"];
    }
    
    if ([[rowData objectForKey:@"kind"] isEqualToString:@"track"]) {
        COJTrackTableCellView *cellView = [tableView makeViewWithIdentifier:@"trackCell" owner:self];
        [cellView setTrack:rowData];
        
        return cellView;
    } else if ([[rowData objectForKey:@"kind"] isEqualToString:@"user"]) {
        COJArtistTableCellView *cellView = [tableView makeViewWithIdentifier:@"artistCell" owner:self];
        [cellView setArtist:rowData];
        
        return cellView;
    } else if ([[rowData objectForKey:@"kind"] isEqualToString:@"playlist"]) {
        COJPlaylistTableCellView *cellView = [tableView makeViewWithIdentifier:@"playlistCell" owner:self];
        [cellView setPlaylist:rowData];
        
        return cellView;
    } else if ([[rowData objectForKey:@"kind"] isEqualToString:@"group"]) {
        COJGroupTableCellView *cellView = [tableView makeViewWithIdentifier:@"groupCell" owner:self];
        [cellView setGroup:rowData];
        
        return cellView;
    } else {
        COJTrackTableCellView *cellView = [tableView makeViewWithIdentifier:@"trackCell" owner:self];
        [cellView.trackTitle setStringValue:@"Something’s wrong …"];
        [cellView.artistName setStringValue:@"/Johannes Wärn, the app’s developer"];
        [cellView.trackImageView setImage:nil];
        [cellView.playingIndicator setImage:nil];
        return cellView;
    }
}

@end
