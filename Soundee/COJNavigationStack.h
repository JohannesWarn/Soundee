//
//  COJNavigationStack.h
//  Soundee
//
//  Created by Johannes Wärn on 02/10/14.
//  Copyright (c) 2014 Johannes Wärn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COJNavigationStack : NSObject

- (NSArray *)currentTableViewData;
- (void)pushTableViewData:(NSArray *)tableViewData;
- (void)popLast;
- (void)popToIndex:(NSInteger)index;
- (void)popToRoot;
- (void)popAll;

@end
