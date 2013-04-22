//
//  BCPerson.m
//  Bonfire
//
//  Created by Scott Petit on 6/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCPerson.h"
#import "NSDate+BasecampKit.h"

@implementation BCPerson

@synthesize avatarURL = _avatarURL;
@synthesize createdDate = _createdDate;
@synthesize emailAddress = _emailAddress;
@synthesize personID = _personID;
@synthesize name = _name;
@synthesize lastUpdated = _lastUpdated;
@synthesize assignedTodosCount = _assignedTodosCount;
@synthesize eventsCount = _eventsCount;

- (id) initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self) 
    {
        self.avatarURL = [dictionary objectForKey:@"avatar_url"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.emailAddress = [dictionary objectForKey:@"email_address"];
        self.personID = [[dictionary objectForKey:@"id"] stringValue];
        self.name = [dictionary objectForKey:@"name"];
        self.lastUpdated = [dictionary objectForKey:@"updated_at"];
        self.assignedTodosCount = [[[dictionary objectForKey:@"assigned_todos"] objectForKey:@"count"] intValue];
        self.eventsCount = [[[dictionary objectForKey:@"events"] objectForKey:@"count"] intValue];
    }
    
    return self;
}

- (id) initPersonWithID:(NSString *)personID
{
    self = [super init];
    if (self) 
    {
        self.personID = personID;
    }
    return self;
}

- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[BCPerson class]])
        return NO;
    
    BCPerson *otherPerson = (BCPerson *) object;
    return [otherPerson.personID isEqualToString:self.personID];
}

@end
