//
//  BCCalendarEvent.h
//  Bonfire
//
//  Created by Scott Petit on 6/21/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCCalendarEvent : NSObject

@property (nonatomic, strong) NSString *calendarEventID;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSMutableArray *comments;

- (id) initWithDictionary:(NSMutableDictionary *) dictionary;

@end
