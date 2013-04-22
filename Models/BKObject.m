//
//  BKObject.m
//  BasecampKit
//
//  Created by Scott Petit on 4/21/13.
//  Copyright (c) 2013 Scott Petit. All rights reserved.
//

#import "BKObject.h"

@implementation BKObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        //no-op
    }
    return self;
}

@end
