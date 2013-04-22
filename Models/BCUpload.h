//
//  BCUpload.h
//  Bonfire
//
//  Created by Scott Petit on 6/25/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCUpload : BKObject

@property (nonatomic, copy) NSString *uploadID;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *attachmentKey;
@property (nonatomic, copy) NSString *attachmentName;
@property (nonatomic) double byteSize;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, strong) NSDate *attachmentCreatedDate;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, strong) NSMutableArray *comments;

@end
