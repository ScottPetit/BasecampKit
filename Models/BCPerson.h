//
//  BCPerson.h
//  Bonfire
//
//  Created by Scott Petit on 6/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

@interface BCPerson : BKObject

@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *personID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lastUpdated;
@property (nonatomic) NSInteger assignedTodosCount;
@property (nonatomic) NSInteger eventsCount;

- (id)initPersonWithId:(NSString *)personId;

@end
