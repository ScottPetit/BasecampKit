//
//  BCUpload.m
//  Bonfire
//
//  Created by Scott Petit on 6/25/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKUpload.h"
#import "BKComment.h"
#import "NSDate+BasecampKit.h"

@implementation BKUpload

- (id)initWithDictionary:(NSMutableDictionary *) dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.uploadID = [dictionary objectForKey:@"id"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.content = [dictionary objectForKey:@"content"];
        self.attachmentKey = [[[dictionary objectForKey:@"attachments"] lastObject] objectForKey:@"key"];
        self.attachmentName = [[[dictionary objectForKey:@"attachments"] lastObject] objectForKey:@"name"];
        self.byteSize = [[[[dictionary objectForKey:@"attachments"] lastObject] objectForKey:@"byte_size"] doubleValue];
        self.contentType = [[[dictionary objectForKey:@"attachments"] lastObject] objectForKey:@"content_type"];
        self.attachmentCreatedDate = [NSDate dateFromString:[[[dictionary objectForKey:@"attachments"] lastObject] objectForKey:@"created_at"]];
        self.url = [[[dictionary objectForKey:@"attachments"] lastObject] objectForKey:@"url"];
        self.creatorID = [[[[dictionary objectForKey:@"attachments"] lastObject] objectForKey:@"creator"] objectForKey:@"id"];
        self.creatorName = [[[[dictionary objectForKey:@"attachments"] lastObject] objectForKey:@"creator"] objectForKey:@"name"];
        
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
