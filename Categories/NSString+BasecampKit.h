//
//  NSString+BasecampKit.h
//  BasecampKit
//
//  Created by Scott Petit on 8/7/12.
//  Copyright (c) 2012 Scott Petit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BasecampKit)

+ (instancetype)urlEscapeString:(NSString *)unencodedString;
+ (instancetype)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary;

@end
