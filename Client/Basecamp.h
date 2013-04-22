//
//  Basecamp.h
//  Basecamp
//
//  Created by Scott Petit on 6/7/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "AFNetworking.h"

@class BKProject;
@class BKPerson;
@class BKDocument;
@class BKTodoList;
@class BKTodo;
@class BKCalendarEvent;
@class BKUpload;
@class BKComment;
@class BKMessage;

typedef void (^BKHTTPClientSuccess)(AFJSONRequestOperation *operation, id responseObject);
typedef void (^BKHTTPClientFailure)(AFJSONRequestOperation *operation, NSError *error);

@interface Basecamp : AFHTTPClient

+ (instancetype)sharedCamp;

@property (nonatomic, copy) NSString *accountID;

//Projects
- (void)getProjectsWithParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)getProjectForID:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Todo lists
- (void)getTodoListsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)getTodosForTodoList:(NSString *)todoListID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)getAssignedTodoListsForPerson:(NSString *)personID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Todos
- (void)getTodo:(NSString *)todoID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Documents
- (void)getDocumentsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)getDocumentWithID:(NSString *)documentID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Calendar Events
- (void)getUpcomingCalendarEventsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)getPastCalendarEventsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)getCalendarEventwithID:(NSString *)calendarEventID forProject:(NSString *)projectID withParamaters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//People
- (void)getPersonWithID:(NSString *)personID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Events
- (void)getEventsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Files
- (void)getAttachmentsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)getUploadWithID:(NSString *)uploadID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Topics
- (void)getTopicsForProject:(BKProject *)project parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Messages
- (void)getMessage:(NSString *)messageID forProject:(BKProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

#pragma mark - Creation/Updating

//Projects
- (void)createProjectWithParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//TodoLists
- (void)createTodoListForProject:(BKProject *)project parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)updateTodoList:(BKTodoList *)list forProject:(BKProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Todos
- (void)createTodoForTodoList:(BKTodoList *)todoList forProject:(BKProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)updateTodo:(BKTodo *)todo forProject:(BKProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Documents
- (void)createDocumentForProject:(BKProject *)project parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Calendar Events
- (void)createCalendarEventForProject:(BKProject *)project parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;
- (void)updateCalendarEvent:(BKCalendarEvent *)calendarEvent forProject:(BKProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Comments
- (void)createCommentForSection:(NSString *)section withIdentifier:(NSString *)sectionID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

//Messages
- (void)createMessageForProject:(BKProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure;

@end
