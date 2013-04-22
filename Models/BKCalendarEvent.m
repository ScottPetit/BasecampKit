//
//  CalendarEvent.m
//  Bonfire
//
//  Created by Scott Petit on 6/21/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKCalendarEvent.h"
#import "NSDate+BasecampKit.h"
#import "BKComment.h"

@implementation BKCalendarEvent

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.calendarEventID = [dictionary objectForKey:@"id"];
        self.summary = [dictionary objectForKey:@"summary"];
        self.description = [dictionary objectForKey:@"description"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.isAllDay = [[dictionary objectForKey:@"all_day"] boolValue];
        self.startDate = [NSDate dateFromString:[dictionary objectForKey:@"starts_at"]];
        self.endDate = [NSDate dateFromString:[dictionary objectForKey:@"ends_at"]];
        self.creatorID = [[dictionary objectForKey:@"creator"] objectForKey:@"id"];
        self.creatorName = [[dictionary objectForKey:@"creator"] objectForKey:@"name"];
        self.url = [dictionary objectForKey:@"url"];
        
        NSArray *commentsArray = [dictionary objectForKey:@"comments"];
        
        for (id commentsDictionary in commentsArray) 
        {
            BKComment *comment = [BKComment objectWithDictionary:commentsDictionary];
            [self.comments addObject:comment];
        }
                    
    }
    return self;
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)comments
{
    if (!_comments)
    {
        _comments = [[NSMutableArray alloc] init];
    }
    return _comments;
}

@end
