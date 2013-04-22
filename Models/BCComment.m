//
//  BCComment.m
//  Bonfire
//
//  Created by Scott Petit on 6/19/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCComment.h"
#import "NSDate+BasecampKit.h"
#import "NIAttributedLabel.h"
#import "SORelativeDateTransformer.h"
#import "NSAttributedString+BasecampKit.h"
#import "NSString+HTML.h"

@implementation BCComment

@synthesize commentID = _commentID;
@synthesize content = _content;
@synthesize createdDate = _createdDate;
@synthesize updatedDate = _updatedDate;
@synthesize creatorID = _creatorID;
@synthesize creatorName = _creatorName;
@synthesize creatorImageURL = _creatorImageURL;
@synthesize fullDescription = _fullDescription;
@synthesize height = _height;

- (id) initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.commentID = [dictionary objectForKey:@"id"];
        self.content = [[dictionary objectForKey:@"content"] stringByConvertingHTMLToPlainText];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];
        self.creatorID = [[[dictionary objectForKey:@"creator"] objectForKey:@"id"] stringValue];
        self.creatorName = [[dictionary objectForKey:@"creator"] objectForKey:@"name"];
        
        SORelativeDateTransformer *dateTransformer = [[SORelativeDateTransformer alloc] init];
        NSString *dateString = [dateTransformer transformedValue:self.updatedDate];
        
        self.fullDescription = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@: %@ \n%@", self.creatorName, self.content, dateString]];
        [self.fullDescription setTextColor:[UIColor secondaryTextColor]];
        [self.fullDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        [self.fullDescription setTextColor:[UIColor primaryTextColor] range:NSMakeRange(0, self.creatorName.length + 1)];
        [self.fullDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] range:NSMakeRange(0, self.creatorName.length + 1)];
        [self.fullDescription setTextColor:[UIColor primaryTextColor] range:NSMakeRange(self.creatorName.length + 1, self.content.length + 1)];
        [self.fullDescription setFont:[UIFont fontWithName:@"HelveticaNeue" size:17] range:NSMakeRange(self.creatorName.length, self.content.length + 1)];
        [self.fullDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0] range:NSMakeRange(self.creatorName.length + self.content.length + 4, dateString.length)];
        
        self.height = [self heightForAttributedStringWithEvent:self];
        
    }
    return self;
}

#pragma mark - Calculating Height

- (CGFloat) heightForAttributedStringWithEvent:(BCComment *) comment
{
    CGSize maximumLabelSize = CGSizeMake(215, 9999);
    
    NIAttributedLabel *description = [[NIAttributedLabel alloc] init];
    description.lineBreakMode = UILineBreakModeWordWrap;
    description.textAlignment = UITextAlignmentLeft;

    description.attributedString = comment.fullDescription;
    CGSize expectedDescriptionLabelSize = [description sizeThatFits:maximumLabelSize];
    CGFloat height = expectedDescriptionLabelSize.height;
    
    return height;
}

@end
