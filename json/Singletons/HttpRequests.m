//
//  CommentPoster.m
//  json
//
//  Created by Patrick Ziegler on 8/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "HttpRequests.h"
#define sURL @"http://snowbrains.com/"
#define sBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation HttpRequests

+(void)postComment:(NSDictionary *)details andCompletion:(CommentCompletionHandler)completion{
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:details];
    [parameters addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"submit_comment",@"json", nil]];
    [HttpRequests postJson:parameters andCompletion:^(BOOL success, NSError *error, id responseObject) {
        completion(success,error);
    }];
}
+(void)postJson:(NSDictionary *)details andCompletion:(JSONCompletionHandler)completion{
    dispatch_async(sBgQueue, ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSURLSessionDataTask *dataTask = [manager POST:sURL parameters:details success:^(NSURLSessionDataTask *task, id responseObject) {
#ifdef DEBUG
            NSLog(@"%@ %@",task, responseObject);
#endif
            if (completion){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES, nil,responseObject);
                });
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
#ifdef DEBUG
            NSLog(@"%@ %@",task, error);
#endif
            if (completion){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, error,nil);
                });
            }
        }];
        [dataTask resume];
    });
}
+(void)getJson:(NSDictionary *)details andCompletion:(JSONCompletionHandler)completion{
    dispatch_async(sBgQueue, ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSURLSessionDataTask *dataTask = [manager GET:sURL parameters:details success:^(NSURLSessionDataTask *task, id responseObject) {
#ifdef DEBUG
            NSLog(@"%@ %@",task, responseObject);
#endif
            if (completion){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES, nil,responseObject);
                });
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
#ifdef DEBUG
            NSLog(@"%@ %@",task, error);
#endif
            if (completion){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, error,nil);
                });
            }
        }];
        [dataTask resume];
    });
}
@end
