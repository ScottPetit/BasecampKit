//
//  Basecamp.m
//  Basecamp
//
//  Created by Scott Petit on 6/7/12.
//  Copyright (c) 2012 Squishy Peach Creative. All rights reserved.
//

#import "Basecamp.h"
#import "BCProject.h"
#import "BCPerson.h"
#import "BCTodoList.h"
#import "BCTodo.h"
#import "BCEvent.h"
#import "BCDocument.h"
#import "BCCalendarEvent.h"
#import "BCUpload.h"
#import "BCAttachment.h"
#import "BCComment.h"
#import "BCTopic.h"
#import "BCMessage.h"
#import "NSString+BasecampKit.h"

#define kBasecampBaseURL @"https://basecamp.com/"
#define kBasecampAuthorizationURL @"https://launchpad.37signals.com/authorization/"

@implementation Basecamp

#pragma mark - Init

+ (instancetype)sharedCampWithAccountId:(NSString *)accountId
{
    static Basecamp *__sharedCamp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedCamp = [[Basecamp alloc] initWithBaseURL:[NSURL URLWithString:kBasecampBaseURL] accountId:accountId];
    });
    
    return __sharedCamp;
}

- (id)initWithBaseURL:(NSURL *)url accountId:(NSString *)accountId
{
    self = [super initWithBaseURL:url];
    if (self) 
    {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
        [self setDefaultHeader:@"User-Agent" value:@"Bonfire (petit.scott@gmail.com)"];
        _accountID = accountId;
    }
    return self;
}

#pragma mark - Projects

- (void)getProjectsWithParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects.json", self.accountID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSMutableArray *projects = [NSMutableArray array];
              
              for (NSMutableDictionary *dictionary in responseObject)
              {
                  BCProject *project = [BCProject objectWithDictionary:dictionary];
                  [projects addObject:project];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, projects);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              if (failure)
              {
                  failure((AFJSONRequestOperation *)operation, error);
              }
          }];
}

- (void)getProjectForID:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              BCProject *project = [BCProject objectWithDictionary:responseObject];
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, project);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Todo Lists

- (void)getTodoListsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {              

              NSMutableArray *lists = [NSMutableArray array];
              
              for (NSMutableDictionary *listsDictionary in responseObject) 
              {
                  BCTodoList *list = [BCTodoList objectWithDictionary:listsDictionary];
                  [lists addObject:list];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, lists);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
    
}

- (void)getAssignedTodoListsForPerson:(NSString *)personID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/people/%@/assigned_todos.json", self.accountID, personID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSMutableArray *lists = [NSMutableArray array];
              
              for (NSMutableDictionary *dictionary in responseObject) 
              {
                  BCTodoList *todoList = [BCTodoList objectWithDictionary:dictionary];
                  [lists addObject:todoList];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, lists);
              }                            
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

- (void)getTodosForTodoList:(NSString *)todoListID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists/%@.json", self.accountID, projectID, todoListID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
              NSMutableArray *todosArray = [[responseObject objectForKey:@"todos"] objectForKey:@"remaining"];
              NSMutableArray *todos = [NSMutableArray array];
              
              for (NSMutableDictionary *todosDict in todosArray) 
              {
                  BCTodo *todo = [BCTodo objectWithDictionary:todosDict];
                  [todos addObject:todo];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, todos);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Todos

- (void)getTodo:(NSString *)todoID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todos/%@.json", self.accountID, projectID, todoID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              BCTodo *todo = [BCTodo objectWithDictionary:responseObject];
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, todo);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Documents

- (void)getDocumentsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/documents.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSMutableArray *documents = [NSMutableArray array];
              
              for (NSMutableDictionary *documentsDict in responseObject) 
              {
                  BCDocument *document = [BCDocument objectWithDictionary:documentsDict];
                  [documents addObject:document];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, documents);
              }              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

- (void)getDocumentWithID:(NSString *)documentID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/documents/%@.json", self.accountID, projectID, documentID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              BCDocument *document = [BCDocument objectWithDictionary:responseObject];
            
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, document);
              }        
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Calendar Events

- (void)getUpcomingCalendarEventsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSMutableArray *calendarEvents = [NSMutableArray array];
              
              for (NSMutableDictionary *calendarEventsDict in responseObject) 
              {
                  BCCalendarEvent *event = [BCCalendarEvent objectWithDictionary:calendarEventsDict];
                  [calendarEvents addObject:event];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, calendarEvents);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

- (void)getPastCalendarEventsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events/past.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {              
              NSLog(@"JSON = %@", responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error = %@", error);              
          }];
}

- (void)getCalendarEventwithID:(NSString *)calendarEventID forProject:(NSString *)projectID withParamaters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events/%@.json", self.accountID, projectID, calendarEventID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              BCCalendarEvent *calendarEvent = [BCCalendarEvent objectWithDictionary:responseObject];
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, calendarEvent);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}


#pragma mark - People

- (void)getPersonWithID:(NSString *)personID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/people/%@.json", self.accountID, personID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              BCPerson *person = [BCPerson objectWithDictionary:responseObject];

              if (success)
              {
                  success((AFJSONRequestOperation *)operation, person);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){              
          }];
}

#pragma mark - Events

- (void)getEventsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/events.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSMutableArray *events = [NSMutableArray array];
              
              NSArray *jsonArray = responseObject;
              
              for (NSMutableDictionary *dictionary in jsonArray) 
              {
                  BCEvent *event = [BCEvent objectWithDictionary:dictionary];
                  [events addObject:event];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, events);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Files

- (void)getAttachmentsForProject:(NSString *)projectID parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/attachments.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSMutableArray *attachments = [NSMutableArray array];
              
              NSArray *jsonArray = responseObject;
              
              for (NSMutableDictionary *dictionary in jsonArray) 
              {
                  BCAttachment *attachment = [BCAttachment objectWithDictionary:dictionary];
                  [attachments addObject:attachment];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, attachments);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

- (void)getUploadWithID:(NSString *)uploadID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/uploads/%@.json", self.accountID, projectID, uploadID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              BCUpload *upload = [BCUpload objectWithDictionary:responseObject];
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, upload);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Topics

- (void)getTopicsForProject:(BCProject *)project parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/topics.json", self.accountID, project.projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSMutableArray *topics = [NSMutableArray array];
              
              for (NSMutableDictionary *topicsDict in responseObject) 
              {
                  BCTopic *topic = [BCTopic objectWithDictionary:topicsDict];
                  [topics addObject:topic];
              }
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, topics);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Messages

- (void)getMessage:(NSString *)messageID forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/messages/%@.json", self.accountID, project.projectID, messageID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              BCMessage *message = [BCMessage objectWithDictionary:responseObject];
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, message);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Creation/Updating

#pragma mark - Projects

- (void)createProjectWithParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects.json", self.accountID];
    
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id responseObject){
               
               BCProject *project = [BCProject objectWithDictionary:responseObject];
               
               if (success)
               {
                   success((AFJSONRequestOperation *)operation, project);
               }
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
           }];
}

#pragma mark - Todo Lists

- (void)createTodoListForProject:(BCProject *)project parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists.json", self.accountID, project.projectID];
    
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               BCTodoList *list = [BCTodoList objectWithDictionary:responseObject];
               
               if (success)
               {
                   success((AFJSONRequestOperation *)operation, list);
               }
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error){
           }];
}

- (void)updateTodoList:(BCTodoList *)list forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists/%@.json", self.accountID, project.projectID, list.todoListID];
    
    [self putPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              
              BCTodoList *list = [BCTodoList objectWithDictionary:responseObject];
              
              if (success)
              {
                  success((AFJSONRequestOperation *)operation, list);
              }
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error = %@", error); 
          }];
}

#pragma mark - Todos

- (void)createTodoForTodoList:(BCTodoList *)todoList forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists/%@/todos.json", self.accountID, project.projectID, todoList.todoListID];
    
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               BCTodo *todo = [BCTodo objectWithDictionary:responseObject];
               
               if (success)
               {
                   success((AFJSONRequestOperation *)operation, todo);
               }
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

- (void)updateTodo:(BCTodo *)todo forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todos/%@.json", self.accountID, project.projectID, todo.todoID];
    
    [self putPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id responseObject){
               
               BCTodo *todo = [BCTodo objectWithDictionary:responseObject];
               
               if (success)
               {
                   success((AFJSONRequestOperation *)operation, todo);
               }
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error); 
           }];
}

#pragma mark - Documents

- (void)createDocumentForProject:(BCProject *)project parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/documents.json", self.accountID, project.projectID];
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id responseObject){
               
               BCDocument *document = [BCDocument objectWithDictionary:responseObject];
               
               if (success)
               {
                   success((AFJSONRequestOperation *)operation, document);
               }
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

#pragma mark - Calendar Events

- (void)createCalendarEventForProject:(BCProject *)project parameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events.json", self.accountID, project.projectID];
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id responseObject){
               NSLog(@"JSON = %@", responseObject);      
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

- (void)updateCalendarEvent:(BCCalendarEvent *)calendarEvent forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events/%@.json", self.accountID, project.projectID, calendarEvent.calendarEventID];
    [self putPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSLog(@"JSON = %@", responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error = %@", error);
          }];
}

#pragma mark - Comments

- (void)createCommentForSection:(NSString *)section withIdentifier:(NSString *)sectionID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/%@/%@/comments.json", self.accountID, projectID, section, sectionID];
    
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id responseObject){
               
               BCComment *comment = [BCComment objectWithDictionary:responseObject];
               
               if (success)
               {
                   success((AFJSONRequestOperation *)operation, comment);
               }
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

#pragma mark - Messages

- (void)createMessageForProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters success:(BKHTTPClientSuccess)success failure:(BKHTTPClientFailure)failure
{
    NSLog(@"Creating a Message");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/messages.json", self.accountID, project.projectID];
    
    [self postPath:path
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject){
               
               BCMessage *message = [BCMessage objectWithDictionary:responseObject];
               
               if (success)
               {
                   success((AFJSONRequestOperation *)operation, message);
               }
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

@end
