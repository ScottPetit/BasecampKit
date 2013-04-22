//
//  NSDate+BasecampKit.m
//  BasecampKit
//
//  Created by Scott Petit on 8/7/12.
//  Copyright (c) 2012 Scott Petit. All rights reserved.
//

#import "NSDate+BasecampKit.h"

@implementation NSDate (BasecampKit)

+ (instancetype)dateFromString:(NSString *)string
{
    NSDate *date = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSString *dateString = string;
    if ([dateString hasSuffix:@"-05:00"])
        dateString = [dateString stringByReplacingOccurrencesOfString:@"-05:00" withString:@""];
    
    date = [formatter dateFromString:dateString];
    
    return date;
}

@end
