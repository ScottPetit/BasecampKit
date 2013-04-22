//
//  BCComment.h
//  Bonfire
//
//  Created by Scott Petit on 6/19/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCComment : NSObject

@property (nonatomic, strong) NSString *commentID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSString *creatorID;
@property (nonatomic, strong) NSString *creatorName;
@property (nonatomic, strong) NSString *creatorImageURL;
@property (nonatomic, strong) NSMutableAttributedString *fullDescription;
@property (nonatomic) CGFloat height;

- (id) initWithDictionary:(NSMutableDictionary *) dictionary;

@end
