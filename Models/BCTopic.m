//
//  BCTopic.m
//  Bonfire
//
//  Created by Scott Petit on 7/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCTopic.h"
#import "NSDate+BasecampKit.h"

@implementation BCTopic

@synthesize topicID = _topicID;
@synthesize title = _title;
@synthesize excerpt = _excerpt;
@synthesize createdDate = _createdDate;
@synthesize updatedDate = _updatedDate;
@synthesize attachmentsCount = _attachmentsCount;
@synthesize lastUpdaterID = _lastUpdaterID;
@synthesize lastUpdaterName = _lastUpdaterName;
@synthesize topicableID = _topicableID;
@synthesize topicType = _topicType;
@synthesize topicableURL = _topicableURL;

- (id) initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.topicID = [[dictionary objectForKey:@"id"] stringValue];
        self.title = [dictionary objectForKey:@"title"];
        self.excerpt = [dictionary objectForKey:@"excerpt"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.attachmentsCount = [[dictionary objectForKey:@"attachments"] intValue];
        self.lastUpdaterID = [[[dictionary objectForKey:@"last_updater"] objectForKey:@"id"] stringValue];
        self.lastUpdaterName = [[dictionary objectForKey:@"last_updater"] objectForKey:@"name"];
        self.topicableID = [[[dictionary objectForKey:@"topicable"] objectForKey:@"id"] stringValue];
        self.topicableURL = [[dictionary objectForKey:@"topicable"] objectForKey:@"url"];
        
        NSString *typeString = [[dictionary objectForKey:@"topicable"] objectForKey:@"type"];
        
        if ([typeString isEqualToString:@"Todo"]) 
        {
            self.topicType = TopicTypeTodo;
        }
        else if ([typeString isEqualToString:@"Document"]) 
        {
            self.topicType = TopicTypeDocument;
        }
        else if ([typeString isEqualToString:@"Message"])
        {
            self.topicType = TopicTypeMessage;
        }
        else if ([typeString isEqualToString:@"Upload"]) 
        {
            self.topicType = TopicTypeUpload;
        }
        else if ([typeString isEqualToString:@"CalendarEvent"]) 
        {
            self.topicType = TopicTypeCalendarEvent;
        }
        else
        {
            NSLog(@"Couldn't find type for %@", typeString);
        }
    }
    return self;
}

@end
