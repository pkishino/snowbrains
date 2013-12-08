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
#define sLatestPosts [NSURL URLWithString:@"http://snowbrains.com/?json=get_recent_posts&count=10"]
#define sBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation PostRetriever

+(void)startHarvesting{
    
}
+(void)stopHarvesting{
    
}
+(void)backgroundFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
}
+(void)getLatestPostRequestWithCompletion:(PostCompletionHandler)completion{
    dispatch_async(sBgQueue, ^{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sLatestPosts];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (completion){
                completion(NO, error);
            }
        } else {
//            NSLog(@"%@ %@", response, responseObject);
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
    [dataTask resume];
    });
}

@end
