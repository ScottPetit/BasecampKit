//
//  TodoList.m
//  Bonfire
//
//  Created by Scott Petit on 6/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKTodoList.h"
#import "Basecamp.h"
#import "NSDate+BasecampKit.h"

@implementation BKTodoList

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) 
    {
        self.todoListID = [[dictionary objectForKey:@"id"] stringValue];
        self.name = [dictionary objectForKey:@"name"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.lastUpdated = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.url = [dictionary objectForKey:@"url"];
        self.position = [[dictionary objectForKey:@"position"] intValue];
        self.completed = [[dictionary objectForKey:@"completed"] boolValue];
                
        if ([dictionary objectForKey:@"description"] != [NSNull null])
        {
            self.description = [dictionary objectForKey:@"description"];
        }
        
        if ([dictionary objectForKey:@"assigned_todos"])
        {
            self.assignedTodosCount = [[dictionary objectForKey:@"assigned_todos"] count];
        }
    }
    
    return self;
}

- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[BKTodoList class]])
    {
        return NO;
    }
    
    BKTodoList *otherList = (BKTodoList *) object;
    return [otherList.todoListID isEqualToString:self.todoListID];
}

@end
