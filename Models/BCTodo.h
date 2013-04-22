//
//  BCTodo.h
//  Bonfire
//
//  Created by Scott Petit on 6/18/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCTodo : BKObject

@property (nonatomic, strong) NSString *todoID;
@property (nonatomic, strong) NSString *todoListID;
@property (nonatomic) int position;
@property (nonatomic, strong) NSString *content;
@property (nonatomic) BOOL isCompleted;
@property (nonatomic, strong) NSDate *completedDate;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic) int commentsCount;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) NSString *assigneeID;
@property (nonatomic, strong) NSString *assigneeType;
@property (nonatomic, strong) NSString *assigneeName;
@property (nonatomic, strong) NSString *completerID;
@property (nonatomic, strong) NSString *completerName;
@property (nonatomic, strong) NSMutableArray *comments;


@end
