//
//  BCMessage.h
//  Bonfire
//
//  Created by Scott Petit on 7/11/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCMessage : NSObject

@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) NSMutableArray *comments;

- (id) initWithDictionary:(NSMutableDictionary *) dictionary;

@end
