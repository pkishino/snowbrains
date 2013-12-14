//
//  CommentPoster.h
//  json
//
//  Created by Patrick Ziegler on 8/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
typedef void (^CommentCompletionHandler)(BOOL success, NSError *error);
typedef void (^JSONCompletionHandler)(BOOL success, NSError *error, id responseObject);

@interface HttpRequests : NSObject

+(void)postComment:(NSDictionary*)details andCompletion:(CommentCompletionHandler)completion;

+(void)postJson:(NSDictionary*)details andCompletion:(JSONCompletionHandler)completion;

+(void)getJson:(NSDictionary *)details andCompletion:(JSONCompletionHandler)completion;

@end
