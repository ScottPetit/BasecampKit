//
//  BCEvent.m
//  Bonfire
//
//  Created by Scott Petit on 6/12/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "BCEvent.h"
#import "NSDate+BasecampKit.h"
#import "NIAttributedLabel.h"
#import "NSAttributedString+BasecampKit.h"
#import "NSString+HTML.h"
#import "SORelativeDateTransformer.h"

@implementation BCEvent

@synthesize eventID = _eventID;
@synthesize creatorID = _creatorID;
@synthesize creatorName = _creatorName;
@synthesize summary = _summary;
@synthesize url = _url;
@synthesize createdDate = _createdDate;
@synthesize updatedDate = _updatedDate;
@synthesize action = _action;
@synthesize task = _task;
@synthesize fullDescription = _fullDescription;
@synthesize type = _type;
@synthesize typeID = _typeID;
@synthesize image = _image;
@synthesize creatorImageURL = _creatorImageURL;
@synthesize height = _height;
@synthesize color = _color;

- (id) initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self) 
    {
        self.eventID = [[dictionary objectForKey:@"id"] stringValue];
        self.creatorID = [[[dictionary objectForKey:@"creator"] objectForKey:@"id"] stringValue];
        self.creatorName = [[dictionary objectForKey:@"creator"] objectForKey:@"name"];
        self.summary = [[dictionary objectForKey:@"summary"] stringByConvertingHTMLToPlainText];
        self.url = [dictionary objectForKey:@"url"];
        self.createdDate = [NSDate dateFromString:[dictionary objectForKey:@"created_at"]];
        self.updatedDate = [NSDate dateFromString:[dictionary objectForKey:@"updated_at"]];

        NSMutableArray *actionArray = [[self.summary componentsSeparatedByString:@":"] mutableCopy];
            
        if (actionArray.count == 1) 
            self.action = [actionArray objectAtIndex:0];
        else
            self.action = [NSString stringWithFormat:@"%@: ", [actionArray objectAtIndex:0]];
            
        [actionArray removeObjectAtIndex:0];
        if (actionArray.count >= 1) 
            self.task = [actionArray componentsJoinedByString:@" "];  
        
        SORelativeDateTransformer *dateTransformer = [[SORelativeDateTransformer alloc] init];
        NSString *dateString = [dateTransformer transformedValue:self.updatedDate];
        
        self.fullDescription = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ %@ \n%@", self.creatorName, self.summary, dateString]];
        [self.fullDescription setTextColor:[UIColor secondaryTextColor]];
        [self.fullDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        [self.fullDescription setTextColor:[UIColor primaryTextColor] range:NSMakeRange(0, self.creatorName.length)];
        [self.fullDescription setFont:[UIFont fontWithName:@"HelveticaNeue" size:17] range:NSMakeRange(0, self.creatorName.length)];
        [self.fullDescription setTextColor:[UIColor primaryTextColor] range:NSMakeRange(self.creatorName.length, self.action.length + 1)];
        [self.fullDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] range:NSMakeRange(self.creatorName.length, self.action.length + 1)];
        [self.fullDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0] range:NSMakeRange(self.creatorName.length + self.summary.length + 3, dateString.length)];
        
        self.height = [self heightForAttributedStringWithEvent:self];
    
        NSArray *array = [self.url componentsSeparatedByString:@"/"];
        
        NSString *typeIDString = [array lastObject];
        NSArray *typeIDArray = [typeIDString componentsSeparatedByString:@"-"];
        self.typeID = [typeIDArray objectAtIndex:0];
        
        if ([self.typeID hasSuffix:@".json"]) 
            self.typeID = [self.typeID stringByReplacingOccurrencesOfString:@".json" withString:@""];
        
        
        NSString *typeString = [array objectAtIndex:array.count - 2];
        
        if ([typeString isEqualToString:@"projects"])
        {
            self.type = EventTypeProject;
            self.image = [UIImage imageNamed:@"project"];
            self.color = [UIColor primaryTextColor];
        }
        else if ([typeString isEqualToString:@"todos"]) 
        {
            self.type = EventTypeTodo;
            self.image = [UIImage imageNamed:@"todo"];
            self.color = [UIColor todoListsColor];
        }
        else if ([typeString isEqualToString:@"todolists"])
        {
            self.type = EventTypeTodoList;
            self.image = [UIImage imageNamed:@"todoList"];
            self.color = [UIColor todoListsColor];
        }
        else if ([typeString isEqualToString:@"documents"])
        {
            self.type = EventTypeDocument;
            self.image = [UIImage imageNamed:@"document"];
            self.color = [UIColor documentsColor];
        }
        else if ([typeString isEqualToString:@"messages"])
        {
            self.type = EventTypeMessage;
            self.image = [UIImage imageNamed:@"message"];
            self.color = [UIColor messagesColor];
        }
        else if ([typeString isEqualToString:@"uploads"])
        {
            self.type = EventTypeUpload;
            self.image = [UIImage imageNamed:@"upload"];
            self.color = [UIColor uploadsColor];
        }
        else if ([typeString isEqualToString:@"calendar_events"])
        {
            self.type = EventTypeCalendarEvent;
            self.image = [UIImage imageNamed:@"date"];
            self.color = [UIColor datesColor];
        }
        else
            NSLog(@"Failed to find type with TypeString = %@", typeString);
    }
    
    return self;
}

#pragma mark - Calculating Height

- (CGFloat) heightForAttributedStringWithEvent:(BCEvent *) event
{
    CGSize maximumLabelSize = CGSizeMake(215, 9999);
    
    NIAttributedLabel *description = [[NIAttributedLabel alloc] init];
    description.lineBreakMode = UILineBreakModeWordWrap;
    description.textAlignment = UITextAlignmentLeft;
    
    description.attributedString = event.fullDescription;
    CGSize expectedDescriptionLabelSize = [description sizeThatFits:maximumLabelSize];
    CGFloat height = expectedDescriptionLabelSize.height;
    
    return height;
}

@end
