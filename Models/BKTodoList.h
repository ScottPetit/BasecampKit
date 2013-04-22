//
//  BCTodoList.h
//  Bonfire
//
//  Created by Scott Petit on 6/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BKTodoList : BKObject

@property (nonatomic, copy) NSString *todoListID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic, copy) NSString *url;
@property (nonatomic) NSInteger position;
@property (nonatomic) BOOL completed;

@property (nonatomic, copy) NSString *projectID;
@property (nonatomic) NSInteger assignedTodosCount;

@end
