//
//  BCTopic.h
//  Bonfire
//
//  Created by Scott Petit on 7/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BKObject.h"

typedef NS_ENUM(NSInteger, BKTopicType) {
    BKTopicTypeTodo = 0,
    BKTopicTypeDocument,
    BKTopicTypeMessage,
    BKTopicTypeUpload,
    BKTopicTypeCalendarEvent,
};

@interface BCTopic : BKObject

@property (nonatomic, strong) NSString *topicID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *excerpt;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic) int attachmentsCount;
@property (nonatomic, strong) NSString *lastUpdaterID;
@property (nonatomic, strong) NSString *lastUpdaterName;
@property (nonatomic, strong) NSString *topicableID;
@property (nonatomic) BKTopicType topicType;
@property (nonatomic, strong) NSString *topicableURL;

@end
