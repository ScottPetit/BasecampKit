//
//  BCComment.m
//  Bonfire
//
//  Created by Scott Petit on 6/19/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKComment.h"
#import "NSDate+BasecampKit.h"
#import "NSString+HTML.h"

@implementation BKComment

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.commentID = [dictionary objectForKey:@"id"];
        self.content = [[dictionary objectForKey:@"content"] stringByConvertingHTMLToPlainText];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.creatorID = [[[dictionary objectForKey:@"creator"] objectForKey:@"id"] stringValue];
        self.creatorName = [[dictionary objectForKey:@"creator"] objectForKey:@"name"];
    }
    return self;
}

@end
