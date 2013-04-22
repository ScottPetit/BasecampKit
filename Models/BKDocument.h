//
//  BCDocument.h
//  Bonfire
//
//  Created by Scott Petit on 6/18/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BKDocument : BKObject

@property (nonatomic, copy) NSString *documentID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, copy) NSString *updaterID;
@property (nonatomic, copy) NSString *updaterName;
@property (nonatomic, strong) NSMutableArray *comments;

@end
