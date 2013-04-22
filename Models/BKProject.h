//
//  BCProject.h
//  Bonfire
//
//  Created by Scott Petit on 6/10/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BKProject : BKObject

@property (nonatomic, copy) NSString *projectID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic, copy) NSString *url;
@property (nonatomic) BOOL isArchived;
@property (nonatomic) NSInteger attachmentsCount;
@property (nonatomic) NSInteger calendarEventsCount;
@property (nonatomic) NSInteger documentsCount;
@property (nonatomic) NSInteger todoListsCount;
@property (nonatomic) NSInteger topicsCount;

@end
