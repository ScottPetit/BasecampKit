//
//  BCComment.h
//  Bonfire
//
//  Created by Scott Petit on 6/19/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BKComment : BKObject

@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *creatorImageURL;

@end
