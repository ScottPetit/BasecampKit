//
//  BCMessage.m
//  Bonfire
//
//  Created by Scott Petit on 7/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCMessage.h"
#import "BCComment.h"
#import "NSDate+BasecampKit.h"

@implementation BCMessage

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) 
    {
        self.messageID = [[dictionary objectForKey:@"id"] stringValue];
        self.subject = [dictionary objectForKey:@"subject"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.content = [dictionary objectForKey:@"content"];
        self.creatorID = [[[dictionary objectForKey:@"creator"] objectForKey:@"id"] stringValue];
        self.creatorName = [[dictionary objectForKey:@"creator"] objectForKey:@"id"];
        
        NSArray *commentsArray = [dictionary objectForKey:@"comments"];
        
        for (id commentsDictionary in commentsArray) 
        {
            BCComment *comment = [BCComment objectWithDictionary:commentsDictionary];
            [self.comments addObject:comment];
        }
    }
    return self;
}

- (NSMutableArray *) comments
{
    if (!_comments)
    {
        _comments = [[NSMutableArray alloc] init];
    }
    return _comments;
}

@end
