//
//  BCDocument.h
//  Bonfire
//
//  Created by Scott Petit on 6/18/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCDocument : NSObject

@property (nonatomic, strong) NSString *documentID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSString *updaterID;
@property (nonatomic, strong) NSString *updaterName;
@property (nonatomic, strong) NSMutableArray *comments;

- (id) initWithDictionary:(NSMutableDictionary *) dictionary;

@end
