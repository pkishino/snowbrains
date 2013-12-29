//
//  PostRetriever.h
//  json
//
//  Created by Patrick Ziegler on 26/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PostCompletionHandler)(BOOL success, NSError *error);

@interface PostRetriever : NSObject

+(void)startHarvesting;
+(void)stopHarvesting;
+(void)backgroundFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
+(void)getLatestPostRequestWithCompletion:(PostCompletionHandler)completion;
+(void)getPostsRequestWithParameters:(NSDictionary*)parameters withCompletion:(PostCompletionHandler)completion;

@end
