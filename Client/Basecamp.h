//
//  Basecamp.h
//  Basecamp
//
//  Created by Scott Petit on 6/7/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@class BCProject;
@class BCPerson;
@class BCDocument;
@class BCTodoList;
@class BCTodo;
@class BCCalendarEvent;
@class BCUpload;
@class BCComment;
@class BCMessage;

@protocol BasecampDelegate <NSObject>

@optional
- (void) applicationRecievedTemporaryToken:(NSString *) token;
- (void) requestForAccessWasDenied;
- (void) applicationWasAuthorizedWithAccessToken:(NSString *) accessToken 
                                  expirationDate:(NSDate *) expiration 
                                 andRefreshToken:(NSString *) refreshToken;
- (void) applicationFailedToAuthorizeWithError:(NSError *) error;
- (void) account:(NSMutableDictionary *) account wasAuthorizedWithAccessToken:(NSString *) accessToken;

//Failure
- (void) failedToReturnObjectWithOperation:(AFHTTPRequestOperation *) operation error:(NSError *) error;

//Projects
- (void) didReturnProjects:(NSMutableArray *) projects withOperation:(AFHTTPRequestOperation *) operation;
- (void) didReturnProject:(BCProject *) project withOperation:(AFHTTPRequestOperation *) operation;

//Todo Lists
- (void) didReturnTodoLists:(NSMutableArray *) lists withOperation:(AFHTTPRequestOperation *) operation;
- (void) didReturnAssignedTodoLists:(NSMutableArray *) lists withOperation:(AFHTTPRequestOperation *) operation;
- (void) didReturnTodos:(NSMutableArray *) todos forTodoList:(BCTodoList *) list withOperation:(AFHTTPRequestOperation *) operation;
- (void) didReturnTodoList:(BCTodoList *) list withOperation:(AFHTTPRequestOperation *) operation;

//Todos
- (void) didReturnTodo:(BCTodo *) todo withOperation:(AFHTTPRequestOperation *) operation;

//Documents
- (void) didReturnDocuments:(NSMutableArray *) documents withOperation:(AFHTTPRequestOperation *) operation;
- (void) didReturnDocument:(BCDocument *) document withOperation:(AFHTTPRequestOperation *) operation;

//Calendar Events
- (void) didReturnUpcomingCalendarEvents:(NSMutableArray *) calendarEvents withOperation:(AFHTTPRequestOperation *) operation;
- (void) didReturnPastCalendarEvents:(NSMutableArray *) calendarEvents withOperation:(AFHTTPRequestOperation *) operation;
- (void) didReturnCalendarEvent:(BCCalendarEvent *) calandarEvent withOperation:(AFHTTPRequestOperation *) operation;

//People
- (void) didReturnPerson:(BCPerson *) person withOperation:(AFHTTPRequestOperation *) operation;

//Events
- (void) didReturnEvents:(NSMutableArray *) events withOperation:(AFHTTPRequestOperation *) operation;

//Files
- (void) didReturnAttachments:(NSMutableArray *) attachments withOperation:(AFHTTPRequestOperation *) operation;
- (void) didReturnUpload:(BCUpload *) upload withOperation:(AFHTTPRequestOperation *) operation;

//Comment
- (void) didReturnComment:(BCComment *) comment withOperation:(AFHTTPRequestOperation *) operation;

//Topics
- (void) didReturnTopics:(NSMutableArray *) topics withOperation:(AFHTTPRequestOperation *) operation;

//Messages
- (void) didReturnMessage:(BCMessage *) message withOperation:(AFHTTPRequestOperation *) operation;

@end

@interface Basecamp : AFHTTPClient

+ (id) sharedCamp;

@property (nonatomic, strong) NSObject <BasecampDelegate> *delegate;
@property (nonatomic) BOOL isAuthorized;
@property (nonatomic) BOOL isExpired;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *accountID;
@property (nonatomic, strong) NSMutableDictionary *account;

@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) BCPerson *me;

//Authorization
- (NSURL *) authorizeURL;
- (BOOL) handleOpenURL:(NSURL *) url;
- (void) applicationWasAuthorizedWithTemporaryToken:(NSString *) token;
- (void) getAccountIDWithAccessToken:(NSString *) token;

//Projects
- (void) getProjectsWithParameters:(NSMutableDictionary *) parameters;
- (void) getProjectForID:(NSString *) projectID andParameters:(NSMutableDictionary *) parameters;

//Todo lists
- (void) getTodoListsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;
- (void) getTodosForTodoList:(NSString *) todoListID forProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;
- (void) getAssignedTodoListsForPerson:(NSString *) personID WithParameters:(NSMutableDictionary *) parameters;

//Todos
- (void) getTodo:(NSString *) todoID forProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;

//Documents
- (void) getDocumentsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;
- (void) getDocumentWithID:(NSString *) documentID forProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;

//Calendar Events
- (void) getUpcomingCalendarEventsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;
- (void) getPastCalendarEventsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;
- (void) getCalendarEventwithID:(NSString *) calendarEventID forProject:(NSString *) projectID withParamaters:(NSMutableDictionary *) parameters;

//People
- (void) getPersonWithID:(NSString *) personID andParameters:(NSMutableDictionary *) parameters;

//Events
- (void) getEventsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;

//Files
- (void) getAttachmentsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;
- (void) getUploadWithID:(NSString *) uploadID forProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;

//Topics
- (void) getTopicsForProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;

//Messages
- (void) getMessage:(NSString *) messageID forProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;

#pragma mark - Creation/Updating

//Projects
- (void) createProjectWithParameters:(NSMutableDictionary *) parameters;

//TodoLists
- (void) createTodoListForProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;
- (void) updateTodoList:(BCTodoList *) list forProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;

//Todos
- (void) createTodoForTodoList:(BCTodoList *) todoList forProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;
- (void) updateTodo:(BCTodo *) todo forProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;

//Documents
- (void) createDocumentForProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;

//Calendar Events
- (void) createCalendarEventForProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;
- (void) updateCalendarEvent:(BCCalendarEvent *) calendarEvent forProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;

//Comments
- (void) createCommentForSection:(NSString *) section withIdentifier:(NSString *) sectionID forProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters;

//Messages
- (void) createMessageForProject:(BCProject *) project withParameters:(NSMutableDictionary *) parameters;

@end
