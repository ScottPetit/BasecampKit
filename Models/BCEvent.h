//
//  BCEvent.h
//  Bonfire
//
//  Created by Scott Petit on 6/12/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCEvent : BKObject

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *task;
@property (nonatomic, strong) NSString *typeID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *creatorImageURL;

@end
