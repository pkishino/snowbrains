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

@interface CommentPoster : NSObject

+(void)postComment:(NSDictionary*)details andCompletion:(CommentCompletionHandler)completion;

@end
