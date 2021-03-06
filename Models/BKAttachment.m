//
//  BCAttachment.m
//  Bonfire
//
//  Created by Scott Petit on 6/25/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKAttachment.h"
#import "NSDate+BasecampKit.h"

@implementation BKAttachment

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.key = [dictionary objectForKey:@"key"];
        self.name = [dictionary objectForKey:@"name"];
        self.byteSize = [[dictionary objectForKey:@"byte_size"] doubleValue];
        self.contentType = [dictionary objectForKey:@"content_type"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.url = [dictionary objectForKey:@"url"];
        self.creatorID = [[dictionary objectForKey:@"creator"] objectForKey:@"id"];
        self.creatorName = [[dictionary objectForKey:@"creator"] objectForKey:@"name"];
        self.attachableID = [[dictionary objectForKey:@"attachable"] objectForKey:@"id"];
        self.attachableType = [[dictionary objectForKey:@"attachable"] objectForKey:@"type"];
        self.attachableURL = [[dictionary objectForKey:@"attachable"] objectForKey:@"url"];
    }
    return self;
}

@end
