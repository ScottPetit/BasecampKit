//
//  BCTodoList.h
//  Bonfire
//
//  Created by Scott Petit on 6/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCTodoList : BKObject

@property (nonatomic, strong) NSString *todoListID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) int position;
@property (nonatomic) BOOL completed;

@property (nonatomic, strong) NSString *projectID;
@property (nonatomic) int assignedTodosCount;

@end
