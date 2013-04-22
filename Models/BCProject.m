//
//  BCProject.m
//  Bonfire
//
//  Created by Scott Petit on 6/10/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCProject.h"
#import "NSDate+BasecampKit.h"

@implementation BCProject

@synthesize projectID = _projectID;
@synthesize name = _name;
@synthesize description = _description;
@synthesize lastUpdated = _lastUpdated;
@synthesize url = _url;
@synthesize isArchived = _isArchived;
@synthesize attachmentsCount = _attachmentsCount;
@synthesize calendarEventsCount = _calendarEventsCount;
@synthesize documentsCount = _documentsCount;
@synthesize todoListsCount = _todoListsCount;
@synthesize topicsCount = _topicsCount;

- (id) initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self) 
    {
        self.projectID = [[dictionary objectForKey:@"id"] stringValue];
        self.name = [dictionary objectForKey:@"name"];
        self.description = [dictionary objectForKey:@"description"];
        self.lastUpdated = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.url = [dictionary objectForKey:@"url"];
        self.isArchived = [[dictionary objectForKey:@"archived"] boolValue];
        
        self.attachmentsCount = [[[dictionary objectForKey:@"attachments"] objectForKey:@"count"] intValue];
        self.calendarEventsCount = [[[dictionary objectForKey:@"calendar_events"] objectForKey:@"count"] intValue];
        self.documentsCount = [[[dictionary objectForKey:@"documents"] objectForKey:@"count"] intValue];
        self.todoListsCount = [[[dictionary objectForKey:@"todolists"] objectForKey:@"remaining_count"] intValue];
        self.topicsCount = [[[dictionary objectForKey:@"topics"] objectForKey:@"count"] intValue];
    }
    
    return self;
}

- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[BCProject class]])
        return NO;
    
    BCProject *otherProject = (BCProject *) object;
    return [otherProject.projectID isEqualToString:self.projectID];
}

@end
