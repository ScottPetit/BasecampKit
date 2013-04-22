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

@interface BKTopic : BKObject

@property (nonatomic, copy) NSString *topicID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *excerpt;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic) NSInteger attachmentsCount;
@property (nonatomic, copy) NSString *lastUpdaterID;
@property (nonatomic, copy) NSString *lastUpdaterName;
@property (nonatomic, copy) NSString *topicableID;
@property (nonatomic) BKTopicType topicType;
@property (nonatomic, copy) NSString *topicableURL;

@end
