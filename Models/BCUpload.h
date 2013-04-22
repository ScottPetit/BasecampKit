//
//  BCUpload.h
//  Bonfire
//
//  Created by Scott Petit on 6/25/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCUpload : NSObject

@property (nonatomic, strong) NSString *uploadID;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *attachmentKey;
@property (nonatomic, strong) NSString *attachmentName;
@property (nonatomic) double byteSize;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSDate *attachmentCreatedDate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) NSMutableArray *comments;

- (id) initWithDictionary:(NSMutableDictionary *) dictionary;

@end
