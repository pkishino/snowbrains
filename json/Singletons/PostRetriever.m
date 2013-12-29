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
const NSString* limit=@"10";
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
    [PostRetriever getPostsRequestWithParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"get_recent_posts",@"json",limit,@"count", nil] withCompletion:completion];
}
+(void)getPostsRequestWithParameters:(NSDictionary *)parameters withCompletion:(PostCompletionHandler)completion{
    NSMutableDictionary *modParameters=[NSMutableDictionary dictionaryWithDictionary:parameters];
    [modParameters addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"get_posts",@"json",limit,@"count", nil]];
    [HttpRequests getJson:modParameters andCompletion:^(BOOL success, NSError *error, id responseObject) {
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
