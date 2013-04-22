//
//  TodoList.m
//  Bonfire
//
//  Created by Scott Petit on 6/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCTodoList.h"
#import "Basecamp.h"
#import "NSDate+BasecampKit.h"

@implementation BCTodoList

@synthesize todoListID = _todoListID;
@synthesize name = _name;
@synthesize description = _description;
@synthesize createdDate = _createdDate;
@synthesize lastUpdated = _lastUpdated;
@synthesize url = _url;
@synthesize position = _position;
@synthesize completed = _completed;
@synthesize projectID = _projectID;
@synthesize assignedTodosCount = _assignedTodosCount;

- (id) initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self) 
    {
        self.todoListID = [[dictionary objectForKey:@"id"] stringValue];
        self.name = [dictionary objectForKey:@"name"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.lastUpdated = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.url = [dictionary objectForKey:@"url"];
        self.position = [[dictionary objectForKey:@"position"] intValue];
        self.completed = [[dictionary objectForKey:@"completed"] boolValue];
        
        if ([self.url hasPrefix:[NSString stringWithFormat:@"https://basecamp.com/%@/api/v1/projects/", [[Basecamp sharedCamp] accountID]]]) 
        {
            NSString *prefix = [NSString stringWithFormat:@"https://basecamp.com/%@/api/v1/projects/", [[Basecamp sharedCamp] accountID]];
            NSString *shortenedURL = [self.url stringByReplacingOccurrencesOfString:prefix withString:@""];
            NSArray *array = [shortenedURL componentsSeparatedByString:@"-"];
            self.projectID = [array objectAtIndex:0];
        }
        
        if ([dictionary objectForKey:@"description"] != [NSNull null]) 
            self.description = [dictionary objectForKey:@"description"];
        
        if ([dictionary objectForKey:@"assigned_todos"])
            self.assignedTodosCount = [[dictionary objectForKey:@"assigned_todos"] count];
    }
    
    return self;
}

- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[BCTodoList class]])
        return NO;
    
    BCTodoList *otherList = (BCTodoList *) object;
    return [otherList.todoListID isEqualToString:self.todoListID];
}

@end
