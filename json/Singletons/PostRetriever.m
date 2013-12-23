//
//  PostRetriever.m
//  json
//
//  Created by Patrick Ziegler on 26/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostRetriever.h"
#import "PostModel.h"
#import "Post.h"
#import "HttpRequests.h"
//#define sLatestPosts [NSURL URLWithString:@"http://snowbrains.com/?json=get_recent_posts&count=10"]
//#define sBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation PostRetriever

+(void)startHarvesting{
    
}
+(void)stopHarvesting{
    
}
+(void)backgroundFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [PostRetriever getLatestPostRequestWithCompletion:^(BOOL success, NSError *error) {
        if(success){
            completionHandler(UIBackgroundFetchResultNewData);
        }else{
            completionHandler(UIBackgroundFetchResultFailed);
        }
    }];
}
+(void)getLatestPostRequestWithCompletion:(PostCompletionHandler)completion{
    
    [HttpRequests getJson:[NSDictionary dictionaryWithObjectsAndKeys:@"get_recent_posts",@"json",@"10",@"count", nil] andCompletion:^(BOOL success, NSError *error, id responseObject) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (completion){
                completion(NO, error);
            }
        } else {
            NSArray *items=responseObject[@"posts"];
            [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSError *error=nil;
                PostModel *model=[[PostModel alloc]initWithDictionary:obj error:&error];
                Post *post=[model saveToCore];
                [post importValuesForKeysWithObject:model];
            }];
            if (completion){
                completion(YES, nil);
            }
        }
    }];
}

@end
