//
//  BCAttachment.h
//  Bonfire
//
//  Created by Scott Petit on 6/25/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCAttachment : BKObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) double byteSize;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) NSString *attachableID;
@property (nonatomic, strong) NSString *attachableType;
@property (nonatomic, strong) NSString *attachableURL;

@end
