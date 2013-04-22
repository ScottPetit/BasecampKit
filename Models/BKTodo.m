//
//  BCTodo.m
//  Bonfire
//
//  Created by Scott Petit on 6/18/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKTodo.h"
#import "BKComment.h"
#import "NSDate+BasecampKit.h"

@implementation BKTodo

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.todoID = [[dictionary objectForKey:@"id"] stringValue];
        self.todoListID = [[dictionary objectForKey:@"todolist_id"] stringValue];
        self.position = [[dictionary objectForKey:@"position"] intValue];
        self.content = [dictionary objectForKey:@"content"];
        self.isCompleted = [[dictionary objectForKey:@"completed"] boolValue];
        self.completedDate = [NSDate dateFromString:[dictionary objectForKey:@"completed_at"]];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.commentsCount = [[dictionary objectForKey:@"comments_count"] intValue];
        self.creatorID = [[[dictionary objectForKey:@"creator"] objectForKey:@"id"] stringValue];
        self.creatorName = [[dictionary objectForKey:@"creator"] objectForKey:@"name"];
        self.assigneeID = [[[dictionary objectForKey:@"assignee"] objectForKey:@"id"] stringValue];
        self.assigneeType = [[dictionary objectForKey:@"assignee"] objectForKey:@"type"];
        self.assigneeName = [[dictionary objectForKey:@"assignee"] objectForKey:@"name"];
        self.completerID = [[[dictionary objectForKey:@"completer"] objectForKey:@"id"] stringValue];
        self.completerName = [[dictionary objectForKey:@"completer"] objectForKey:@"name"];
        
        NSArray *commentsArray = [dictionary objectForKey:@"comments"];
        
        for (id commentsDictionary in commentsArray) 
        {
            BKComment *comment = [BKComment objectWithDictionary:commentsDictionary];
            [self.comments addObject:comment];
        }
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[BKTodo class]])
    {
        return NO;
    }
    
    BKTodo *otherTodo = (BKTodo *) object;
    return [otherTodo.todoID isEqualToString:self.todoID];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *) comments
{
    if (!_comments)
    {
        _comments = [[NSMutableArray alloc] init];
    }
    return _comments;
}

@end
