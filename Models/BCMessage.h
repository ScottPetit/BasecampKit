//
//  BCMessage.h
//  Bonfire
//
//  Created by Scott Petit on 7/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCMessage : BKObject

@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, strong) NSMutableArray *comments;

@end
