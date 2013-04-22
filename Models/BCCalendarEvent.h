//
//  BCCalendarEvent.h
//  Bonfire
//
//  Created by Scott Petit on 6/21/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCCalendarEvent : BKObject

@property (nonatomic, copy) NSString *calendarEventID;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSMutableArray *comments;

@end
