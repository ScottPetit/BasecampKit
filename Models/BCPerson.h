//
//  BCPerson.h
//  Bonfire
//
//  Created by Scott Petit on 6/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCPerson : BKObject

@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *personID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastUpdated;
@property (nonatomic) int assignedTodosCount;
@property (nonatomic) int eventsCount;

@end
