//
//  BCDocument.m
//  Bonfire
//
//  Created by Scott Petit on 6/18/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKDocument.h"
#import "NSDate+BasecampKit.h"
#import "BKComment.h"

@implementation BKDocument

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.documentID = [dictionary objectForKey:@"id"];
        self.title = [dictionary objectForKey:@"title"];
        self.content = [dictionary objectForKey:@"content"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.updaterID = [[dictionary objectForKey:@"last_updated"] objectForKey:@"id"];
        self.updaterName = [[dictionary objectForKey:@"last_updated"] objectForKey:@"name"];
        
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
    if (![object isKindOfClass:[BKDocument class]])
    {
        return NO;
    }
    
    BKDocument *otherDocument = (BKDocument *) object;
    return [otherDocument.documentID isEqualToString:self.documentID];
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
