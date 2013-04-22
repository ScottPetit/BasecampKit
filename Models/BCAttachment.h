//
//  BCAttachment.h
//  Bonfire
//
//  Created by Scott Petit on 6/25/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCAttachment : BKObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) double byteSize;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *attachableID;
@property (nonatomic, copy) NSString *attachableType;
@property (nonatomic, copy) NSString *attachableURL;

@end
