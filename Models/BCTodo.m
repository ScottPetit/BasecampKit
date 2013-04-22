//
//  BCTodo.m
//  Bonfire
//
//  Created by Scott Petit on 6/18/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCTodo.h"
#import "BCComment.h"
#import "NSDate+BasecampKit.h"

@implementation BCTodo

@synthesize todoID = _todoID;
@synthesize todoListID = _todoListID;
@synthesize position = _position;
@synthesize content = _content;
@synthesize isCompleted = _isCompleted;
@synthesize completedDate = _completedDate;
@synthesize dueDate = _dueDate;
@synthesize createdDate = _createdDate;
@synthesize updatedDate = _updatedDate;
@synthesize commentsCount = _commentsCount;
@synthesize creatorID = _creatorID;
@synthesize creatorName = _creatorName;
@synthesize assigneeID = _assigneeID;
@synthesize assigneeType = _assigneeType;
@synthesize assigneeName = _assigneeName;
@synthesize completerID = _completerID;
@synthesize completerName = _completerName;
@synthesize comments = _comments;

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
            BCComment *comment = [BCComment objectWithDictionary:commentsDictionary];
            [self.comments addObject:comment];
        }
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[BCTodo class]])
    {
        return NO;
    }
    
    BCTodo *otherTodo = (BCTodo *) object;
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
