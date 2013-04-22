//
//  BKObject.h
//  BasecampKit
//
//  Created by Scott Petit on 4/21/13.
//  Copyright (c) 2013 Scott Petit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKObject : NSObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
