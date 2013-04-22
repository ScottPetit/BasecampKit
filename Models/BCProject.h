//
//  BCProject.h
//  Bonfire
//
//  Created by Scott Petit on 6/10/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCProject : NSObject

@property (nonatomic, strong) NSString *projectID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) BOOL isArchived;
@property (nonatomic) int attachmentsCount;
@property (nonatomic) int calendarEventsCount;
@property (nonatomic) int documentsCount;
@property (nonatomic) int todoListsCount;
@property (nonatomic) int topicsCount;

- (id) initWithDictionary:(NSMutableDictionary *) dictionary;

@end
