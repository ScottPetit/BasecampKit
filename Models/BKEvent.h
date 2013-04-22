//
//  BCEvent.h
//  Bonfire
//
//  Created by Scott Petit on 6/12/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BKEvent : BKObject

@property (nonatomic, copy) NSString *eventID;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *task;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *creatorImageURL;

@end
