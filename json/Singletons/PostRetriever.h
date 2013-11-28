//
//  PostRetriever.h
//  json
//
//  Created by Patrick Ziegler on 26/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFURLSessionManager.h>
typedef void (^PostCompletionHandler)(BOOL success, NSError *error,NSArray *array);

@interface PostRetriever : NSObject

+(void)startHarvesting;
+(void)stopHarvesting;
+(BOOL)createBackgroundFetch;
+(void)getLatestPostRequestWithCompletion:(PostCompletionHandler)completion;

@end
