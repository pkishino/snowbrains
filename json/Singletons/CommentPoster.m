//
//  CommentPoster.m
//  json
//
//  Created by Patrick Ziegler on 8/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommentPoster.h"
#define sURL @"http://snowbrains.com/"
#define sBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation CommentPoster

+(void)postComment:(NSDictionary *)details andCompletion:(CommentCompletionHandler)completion{
    NSString *name=[[NSUserDefaults standardUserDefaults]valueForKey:@"name"];
    NSString *email=[[NSUserDefaults standardUserDefaults]valueForKey:@"email"];
    if(name&&email){
    dispatch_async(sBgQueue, ^{
        NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:details];
        [parameters addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"submit_comment",@"json",name,@"name",email,@"email", nil]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSURLSessionDataTask *dataTask = [manager POST:sURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@ %@",task, responseObject);
            if (completion){
                completion(YES, nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@ %@",task, error);
            if (completion){
                completion(NO, nil);
            }
        }];
        [dataTask resume];
    });
    }else{
    }
}
@end
