//
//  BCPerson.m
//  Bonfire
//
//  Created by Scott Petit on 6/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKPerson.h"
#import "NSDate+BasecampKit.h"

@implementation BKPerson

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
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

- (id)initPersonWithId:(NSString *)personId
{
    self = [super init];
    if (self) 
    {
        self.personID = personId;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[BKPerson class]])
    {
        return NO;
    }
    
    BKPerson *otherPerson = (BKPerson *) object;
    return [otherPerson.personID isEqualToString:self.personID];
}

@end
