//
//  BCTodo.h
//  Bonfire
//
//  Created by Scott Petit on 6/18/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCTodo : BKObject

@property (nonatomic, copy) NSString *todoID;
@property (nonatomic, copy) NSString *todoListID;
@property (nonatomic) NSInteger position;
@property (nonatomic, copy) NSString *content;
@property (nonatomic) BOOL isCompleted;
@property (nonatomic, strong) NSDate *completedDate;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic) NSInteger commentsCount;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *assigneeID;
@property (nonatomic, copy) NSString *assigneeType;
@property (nonatomic, copy) NSString *assigneeName;
@property (nonatomic, copy) NSString *completerID;
@property (nonatomic, copy) NSString *completerName;
@property (nonatomic, strong) NSMutableArray *comments;


@end
