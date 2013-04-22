//
//  BCEvent.m
//  Bonfire
//
//  Created by Scott Petit on 6/12/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCEvent.h"
#import "NSDate+BasecampKit.h"
#import "NSString+HTML.h"

@implementation BCEvent

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) 
    {
        self.eventID = [[dictionary objectForKey:@"id"] stringValue];
        self.creatorID = [[[dictionary objectForKey:@"creator"] objectForKey:@"id"] stringValue];
        self.creatorName = [[dictionary objectForKey:@"creator"] objectForKey:@"name"];
        self.summary = [[dictionary objectForKey:@"summary"] stringByConvertingHTMLToPlainText];
        self.url = [dictionary objectForKey:@"url"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
    }
    return self;
}

@end
