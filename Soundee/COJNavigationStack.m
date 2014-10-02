//
//  COJNavigationStack.m
//  Soundee
//
//  Created by Johannes Wärn on 02/10/14.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import "COJNavigationStack.h"

@implementation COJNavigationStack
{
    NSMutableArray *_tableViewDataStack;
}

- (id)init
{
    self = [super init];
    if (self) {
        _tableViewDataStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)currentTableViewData
{
    return [_tableViewDataStack lastObject];
}

- (void)pushTableViewData:(NSArray *)tableViewData
{
    [_tableViewDataStack addObject:tableViewData];
}

- (void)popLast
{
    if (_tableViewDataStack.count > 1) {
        [_tableViewDataStack removeLastObject];
    }
}

- (void)popToIndex:(NSInteger)index
{
    if (_tableViewDataStack.count > 1) {
        [_tableViewDataStack removeObjectsInRange:NSMakeRange((index + 1), _tableViewDataStack.count - (index + 1))];
    }
}

- (void)popToRoot
{
    [self popToIndex:0];
}

- (void)popAll
{
    [_tableViewDataStack removeAllObjects];
}

@end
