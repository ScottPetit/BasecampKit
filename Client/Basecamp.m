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
#import "JSONKit.h"
#import "NSString+BasecampKit.h"

#define kBasecampBaseURL @"https://basecamp.com/"
#define kBasecampAuthorizationURL @"https://launchpad.37signals.com/authorization/"

@interface Basecamp()

@end

@implementation Basecamp

@synthesize delegate = _delegate;
@synthesize isAuthorized = _isAuthorized;
@synthesize isExpired = _isExpired;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;
@synthesize refreshToken = _refreshToken;
@synthesize accountID = _accountID;
@synthesize account = _account;
@synthesize people = _people;
@synthesize me = _me;

#pragma mark - Init

+ (id) sharedCamp
{
    static Basecamp *__sharedCamp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedCamp = [[Basecamp alloc] initWithBaseURL:[NSURL URLWithString:kBasecampBaseURL]];
    });
    
    return __sharedCamp;
}

- (id) initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) 
    {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
        [self setDefaultHeader:@"User-Agent" value:@"Bonfire (petit.scott@gmail.com)"];
    }
    return self;
}

#pragma mark - Authorization

- (NSURL *) authorizeURL
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"web_server", @"type", kClientID, @"client_id", kRedirectPath, @"redirect_uri", nil];
    NSString *string = [NSString addQueryStringToUrlString:[NSString stringWithFormat:@"%@/new", kBasecampAuthorizationURL] withDictionary:dictionary];
    NSURL *url = [NSURL URLWithString:string];
    return url;
}

- (BOOL) handleOpenURL:(NSURL *) url
{
    if (!url) return NO;
    
    NSString *URLString = [url absoluteString];
    if ([URLString hasPrefix:kRedirectPath]) 
    {
        if ([URLString hasPrefix:[NSString stringWithFormat:@"%@?code=", kRedirectPath]]) 
        {
            NSString *code = [URLString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@?code=", kRedirectPath] withString:@""];
            [self applicationWasAuthorizedWithTemporaryToken:code];
            
            if ([self.delegate respondsToSelector:@selector(applicationRecievedTemporaryToken:)])
                [self.delegate applicationRecievedTemporaryToken:code];
        }
        else if ([URLString hasPrefix:[NSString stringWithFormat:@"%@?error=access_denied", kRedirectPath]]) 
        {
            if ([self.delegate respondsToSelector:@selector(requestForAccessWasDenied)]) 
                [self.delegate requestForAccessWasDenied];
        }
    }
    else return NO; 
        
    return YES;
}

- (void) applicationWasAuthorizedWithTemporaryToken:(NSString *)token
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"web_server", @"type", kClientID, @"client_id", kClientSecret, @"client_secret", kRedirectPath, @"redirect_uri", token, @"code", nil];
    
    AFHTTPClient *authorizationClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBasecampAuthorizationURL]];
    [authorizationClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [authorizationClient setParameterEncoding:AFJSONParameterEncoding];
    
    [authorizationClient postPath:@"token" 
                       parameters:parameters 
                          success:^(AFHTTPRequestOperation *operation, id responseObject){
                              self.isAuthorized = YES;
                              self.accessToken = [responseObject objectForKey:@"access_token"];
                              self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[[responseObject objectForKey:@"expires_in"] doubleValue]];
                              self.refreshToken = [responseObject objectForKey:@"refresh_token"];
                              
                              [[NSUserDefaults standardUserDefaults] setBool:self.isAuthorized forKey:kIsAuthorized];
                              [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessToken];
                              [[NSUserDefaults standardUserDefaults] setObject:self.refreshToken forKey:kRefreshToken];
                              [[NSUserDefaults standardUserDefaults] setObject:self.expirationDate forKey:kExpirationDate];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              
                              [self setAuthorizationHeaderWithToken:self.accessToken];

                              if ([self.delegate respondsToSelector:@selector(applicationWasAuthorizedWithAccessToken:expirationDate:andRefreshToken:)]) 
                                  [self.delegate applicationWasAuthorizedWithAccessToken:self.accessToken 
                                                                          expirationDate:self.expirationDate 
                                                                         andRefreshToken:self.refreshToken];

                              [self getAccountIDWithAccessToken:self.accessToken];
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error){
                              if ([self.delegate respondsToSelector:@selector(applicationFailedToAuthorizeWithError:)]) 
                                  [self.delegate applicationFailedToAuthorizeWithError:error];
                          }];
}

- (void) getAccountIDWithAccessToken:(NSString *)token
{
    AFHTTPClient *accountClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://launchpad.37signals.com/authorization.json"]];
    [accountClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [accountClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [accountClient setDefaultHeader:@"User-Agent" value:@"Bonfire (petit.scott@gmail.com)"];
    [accountClient setAuthorizationHeaderWithToken:token];
    
    [accountClient getPath:@"" 
                parameters:nil 
                   success:^(AFHTTPRequestOperation *operation, id JSON){                       
                       NSArray *accounts = [JSON objectForKey:@"accounts"];
                       
                       for (NSDictionary *accountsDict in accounts) 
                       {
                           if ([[accountsDict objectForKey:@"product"] isEqualToString:@"bcx"]) 
                           { 
                               self.accountID = [accountsDict objectForKey:@"id"];
                               self.account = [accountsDict mutableCopy];
                               
                               [[NSUserDefaults standardUserDefaults] setObject:self.accountID forKey:kAccountID];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                               
                               if ([self.delegate respondsToSelector:@selector(account:wasAuthorizedWithAccessToken:)]) 
                                   [self.delegate account:self.account wasAuthorizedWithAccessToken:token];  
                           }
                       }
                   }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                       NSLog(@"Failure with Error %@", error);
                   }];
    
}

#pragma mark - Projects

- (void) getProjectsWithParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects.json", self.accountID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {              
              NSMutableArray *projects = [NSMutableArray array];
              
              for (NSMutableDictionary *dictionary in JSON) 
              {
                  BCProject *project = [[BCProject alloc] initWithDictionary:dictionary];
                  [projects addObject:project];
              } 

              if ([self.delegate respondsToSelector:@selector(didReturnProjects:withOperation:)])
                  [self.delegate didReturnProjects:projects withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error = %@, for operation = %@", error, operation);
          }];
}

- (void) getProjectForID:(NSString *) projectID andParameters:(NSMutableDictionary *) parameters
{    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {                         
              BCProject *project = [[BCProject alloc] initWithDictionary:JSON];
              
              if ([self.delegate respondsToSelector:@selector(didReturnProject:withOperation:)])
                  [self.delegate didReturnProject:project withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Todo Lists

- (void) getTodoListsForProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {              
              NSMutableArray *lists = [NSMutableArray array];
              
              for (NSMutableDictionary *listsDictionary in JSON) 
              {
                  BCTodoList *list = [[BCTodoList alloc] initWithDictionary:listsDictionary];
                  [lists addObject:list];
              }
            
              if ([self.delegate respondsToSelector:@selector(didReturnTodoLists:withOperation:)])
                  [self.delegate didReturnTodoLists:lists withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
    
}

- (void) getAssignedTodoListsForPerson:(NSString *)personID WithParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/people/%@/assigned_todos.json", self.accountID, personID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {              
              NSMutableArray *lists = [NSMutableArray array];
              
              for (NSMutableDictionary *dictionary in JSON) 
              {
                  BCTodoList *todoList = [[BCTodoList alloc] initWithDictionary:dictionary];
                  [lists addObject:todoList];
              }
              
              if ([self.delegate respondsToSelector:@selector(didReturnAssignedTodoLists:withOperation:)])
                  [self.delegate didReturnAssignedTodoLists:lists withOperation:operation];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

- (void) getTodosForTodoList:(NSString *) todoListID forProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists/%@.json", self.accountID, projectID, todoListID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {
              BCTodoList *todoList = [[BCTodoList alloc] initWithDictionary:JSON];
              
              NSMutableArray *todosArray = [[JSON objectForKey:@"todos"] objectForKey:@"remaining"];
              NSMutableArray *todos = [NSMutableArray array];
              
              for (NSMutableDictionary *todosDict in todosArray) 
              {
                  BCTodo *todo = [[BCTodo alloc] initWithDictionary:todosDict];
                  [todos addObject:todo];
              }
              
              if ([self.delegate respondsToSelector:@selector(didReturnTodos:forTodoList:withOperation:)])
                  [self.delegate didReturnTodos:todos forTodoList:todoList withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Todos

- (void)getTodo:(NSString *)todoID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todos/%@.json", self.accountID, projectID, todoID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {                            
              BCTodo *todo = [[BCTodo alloc] initWithDictionary:JSON];
              
              if ([self.delegate respondsToSelector:@selector(didReturnTodo:withOperation:)])
                  [self.delegate didReturnTodo:todo withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Documents

- (void) getDocumentsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/documents.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {                            
              NSMutableArray *documents = [[NSMutableArray alloc] init];
              
              for (NSMutableDictionary *documentsDict in JSON) 
              {
                  BCDocument *document = [[BCDocument alloc] initWithDictionary:documentsDict];
                  [documents addObject:document];
              }
              
              if ([self.delegate respondsToSelector:@selector(didReturnDocuments:withOperation:)])
                  [self.delegate didReturnDocuments:documents withOperation:operation];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

- (void) getDocumentWithID:(NSString *) documentID forProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/documents/%@.json", self.accountID, projectID, documentID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {             
              BCDocument *document = [[BCDocument alloc] initWithDictionary:JSON];
            
              if ([self.delegate respondsToSelector:@selector(didReturnDocument:withOperation:)])
                  [self.delegate didReturnDocument:document withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Calendar Events

- (void) getUpcomingCalendarEventsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {
              NSMutableArray *calendarEvents = [NSMutableArray array];
              
              for (NSMutableDictionary *calendarEventsDict in JSON) 
              {
                  BCCalendarEvent *event = [[BCCalendarEvent alloc] initWithDictionary:calendarEventsDict];
                  [calendarEvents addObject:event];
              }
              
              if ([self.delegate respondsToSelector:@selector(didReturnUpcomingCalendarEvents:withOperation:)])
                  [self.delegate didReturnUpcomingCalendarEvents:calendarEvents withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

- (void) getPastCalendarEventsForProject:(NSString *) projectID withParameters:(NSMutableDictionary *) parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events/past.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {              
              NSLog(@"JSON = %@", JSON);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error = %@", error);              
          }];
}

- (void) getCalendarEventwithID:(NSString *) calendarEventID forProject:(NSString *) projectID withParamaters:(NSMutableDictionary *) parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events/%@.json", self.accountID, projectID, calendarEventID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {      
              BCCalendarEvent *calendarEvent = [[BCCalendarEvent alloc] initWithDictionary:JSON];
              
              if ([self.delegate respondsToSelector:@selector(didReturnCalendarEvent:withOperation:)])
                  [self.delegate didReturnCalendarEvent:calendarEvent withOperation:operation];

          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}


#pragma mark - People

- (void) getPersonWithID:(NSString *)personID andParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/people/%@.json", self.accountID, personID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {  
              BCPerson *person = [[BCPerson alloc] initWithDictionary:JSON];
              
              if ([self.people containsObject:person]) 
                  [self.people replaceObjectAtIndex:[self.people indexOfObject:person] withObject:person];
              else
                  [self.people addObject:person];
              
              if ([personID isEqualToString:@"me"]) 
                  self.me = person;
              
                  
              if ([self.delegate respondsToSelector:@selector(didReturnPerson:withOperation:)])
                  [self.delegate didReturnPerson:person withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){              
          }];
}

#pragma mark - Events

- (void) getEventsForProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/events.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {
              NSMutableArray *events = [NSMutableArray array];
              
              NSArray *jsonArray = JSON;
              
              for (NSMutableDictionary *dictionary in jsonArray) 
              {
                  BCEvent *event = [[BCEvent alloc] initWithDictionary:dictionary];
                  [events addObject:event];
              }
              
              if ([self.delegate respondsToSelector:@selector(didReturnEvents:withOperation:)])
                  [self.delegate didReturnEvents:events withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Files

- (void) getAttachmentsForProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/attachments.json", self.accountID, projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {
              NSMutableArray *attachments = [NSMutableArray array];
              
              NSArray *jsonArray = JSON;
              
              for (NSMutableDictionary *dictionary in jsonArray) 
              {
                  BCAttachment *attachment = [[BCAttachment alloc] initWithDictionary:dictionary];
                  [attachments addObject:attachment];
              }
              
              if ([self.delegate respondsToSelector:@selector(didReturnAttachments:withOperation:)])
                  [self.delegate didReturnAttachments:attachments withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

- (void) getUploadWithID:(NSString *)uploadID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/uploads/%@.json", self.accountID, projectID, uploadID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {
              BCUpload *upload = [[BCUpload alloc] initWithDictionary:JSON];
              
              if ([self.delegate respondsToSelector:@selector(didReturnUpload:withOperation:)])
                  [self.delegate didReturnUpload:upload withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Topics

- (void) getTopicsForProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/topics.json", self.accountID, project.projectID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {
              NSMutableArray *topics = [NSMutableArray array];
              
              for (NSMutableDictionary *topicsDict in JSON) 
              {
                  BCTopic *topic = [[BCTopic alloc] initWithDictionary:topicsDict];
                  [topics addObject:topic];
              }
              
              if ([self.delegate respondsToSelector:@selector(didReturnTopics:withOperation:)])
                  [self.delegate didReturnTopics:topics withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Messages

- (void) getMessage:(NSString *)messageID forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/messages/%@.json", self.accountID, project.projectID, messageID];
    [self getPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON) {
              BCMessage *message = [[BCMessage alloc] initWithDictionary:JSON];
              
              if ([self.delegate respondsToSelector:@selector(didReturnMessage:withOperation:)])
                  [self.delegate didReturnMessage:message withOperation:operation];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
          }];
}

#pragma mark - Creation/Updating

#pragma mark - Projects

- (void) createProjectWithParameters:(NSMutableDictionary *) parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects.json", self.accountID];
    
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id JSON){
               BCProject *project = [[BCProject alloc] initWithDictionary:JSON];
               
               if ([self.delegate respondsToSelector:@selector(didReturnProject:withOperation:)])
                   [self.delegate didReturnProject:project withOperation:operation];
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
           }];
}

#pragma mark - Todo Lists

- (void) createTodoListForProject:(BCProject *)project withParameters:(NSMutableDictionary *) parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists.json", self.accountID, project.projectID];
    
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id JSON) {
               BCTodoList *list = [[BCTodoList alloc] initWithDictionary:JSON];
               
               if ([self.delegate respondsToSelector:@selector(didReturnTodoList:withOperation:)])
                   [self.delegate didReturnTodoList:list withOperation:operation];
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error){
           }];
}

- (void) updateTodoList:(BCTodoList *)list forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists/%@.json", self.accountID, project.projectID, list.todoListID];
    
    [self putPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON){
              NSLog(@"json = %@", JSON);
              
            //TodoList *list = [[TodoList alloc] initWithDictionary:JSON];
              
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error = %@", error); 
          }];
}

#pragma mark - Todos

- (void) createTodoForTodoList:(BCTodoList *)todoList forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todolists/%@/todos.json", self.accountID, project.projectID, todoList.todoListID];
    
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id JSON) {
               BCTodo *todo = [[BCTodo alloc] initWithDictionary:JSON];
               
               if ([self.delegate respondsToSelector:@selector(didReturnTodo:withOperation:)])
                   [self.delegate didReturnTodo:todo withOperation:operation];
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

- (void) updateTodo:(BCTodo *)todo forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/todos/%@.json", self.accountID, project.projectID, todo.todoID];
    
    [self putPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id JSON){
               BCTodo *todo = [[BCTodo alloc] initWithDictionary:JSON];
               
               if ([self.delegate respondsToSelector:@selector(didReturnTodo:withOperation:)])
                   [self.delegate didReturnTodo:todo withOperation:operation];
               
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error); 
           }];
}

#pragma mark - Documents

- (void) createDocumentForProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/documents.json", self.accountID, project.projectID];
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id JSON){
                BCDocument *document = [[BCDocument alloc] initWithDictionary:JSON];
               
               if ([self.delegate respondsToSelector:@selector(didReturnDocument:withOperation:)])
                   [self.delegate didReturnDocument:document withOperation:operation];
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

#pragma mark - Calendar Events

- (void) createCalendarEventForProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events.json", self.accountID, project.projectID];
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id JSON){
               NSLog(@"JSON = %@", JSON);      
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

- (void) updateCalendarEvent:(BCCalendarEvent *)calendarEvent forProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/calendar_events/%@.json", self.accountID, project.projectID, calendarEvent.calendarEventID];
    [self putPath:path 
       parameters:parameters 
          success:^(AFHTTPRequestOperation *operation, id JSON){
              NSLog(@"JSON = %@", JSON);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error = %@", error);
          }];
}

#pragma mark - Comments

- (void) createCommentForSection:(NSString *)section withIdentifier:(NSString *)sectionID forProject:(NSString *)projectID withParameters:(NSMutableDictionary *)parameters
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/%@/%@/comments.json", self.accountID, projectID, section, sectionID];
    
    [self postPath:path 
        parameters:parameters 
           success:^(AFHTTPRequestOperation *operation, id JSON){
               BCComment *comment = [[BCComment alloc] initWithDictionary:JSON];
               
               if ([self.delegate respondsToSelector:@selector(didReturnComment:withOperation:)])
                   [self.delegate didReturnComment:comment withOperation:operation];
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

#pragma mark - Messages

- (void) createMessageForProject:(BCProject *)project withParameters:(NSMutableDictionary *)parameters
{
    NSLog(@"Creating a Message");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/projects/%@/messages.json", self.accountID, project.projectID];
    
    [self postPath:path
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id JSON){
               BCMessage *message = [[BCMessage alloc] initWithDictionary:JSON];
               
               if ([self.delegate respondsToSelector:@selector(didReturnMessage:withOperation:)])
                   [self.delegate didReturnMessage:message withOperation:operation];
           }failure:^(AFHTTPRequestOperation *operation, NSError *error){
               NSLog(@"Error = %@", error);
           }];
}

#pragma mark - Getter Methods/Lazy Instantiation

- (NSString *) accessToken
{
    if (!_accessToken) _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    return _accessToken;
}

- (NSString *) refreshToken
{
    if (!_refreshToken) _refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:kRefreshToken];
    return _refreshToken;
}

- (BOOL) isExpired
{
    if (!self.expirationDate)
        self.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kExpirationDate];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                     fromDate:date];
    NSDate *today = [cal dateFromComponents:comps];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate:today options:0];
    
    if ([self.expirationDate compare:yesterday] == NSOrderedDescending)
        return NO;
    else 
    {
        self.isAuthorized = NO;
        [[NSUserDefaults standardUserDefaults] setBool:self.isAuthorized forKey:kIsAuthorized];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

- (BOOL) isAuthorized
{
    if (!_isAuthorized) _isAuthorized = [[NSUserDefaults standardUserDefaults] boolForKey:kIsAuthorized];
    return _isAuthorized;
}

- (NSString *) accountID
{
    if (!_accountID) _accountID = [[NSUserDefaults standardUserDefaults] objectForKey:kAccountID];
    return _accountID;
}

- (NSMutableArray *) people
{
    if (!_people) _people = [[NSMutableArray alloc] init];
    return _people;
}

@end
