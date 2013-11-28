//
//  PostRetriever.m
//  json
//
//  Created by Patrick Ziegler on 26/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostRetriever.h"
#import "PostModel.h"
#import "ImageModel.h"
#import "AttachmentModel.h"
#import "Post.h"
#define sLatestPosts [NSURL URLWithString:@"http://snowbrains.com/?json=get_recent_posts&count=10"]

@implementation PostRetriever

+(void)startHarvesting{
    
}
+(void)stopHarvesting{
    
}
+(BOOL)createBackgroundFetch{
    return YES;
}
+(void)getLatestPostRequestWithCompletion:(PostCompletionHandler)completion{
    NSMutableArray *posts=[NSMutableArray array];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sLatestPosts];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (completion){
                completion(NO, error,nil);
            }
        } else {
//            NSLog(@"%@ %@", response, responseObject);
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            NSArray *items=responseObject[@"posts"];
                [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSError *error=nil;
                    PostModel *model=[[PostModel alloc]initWithDictionary:obj error:&error];
//                    model.thumbnail_images.oID=model.oID;
//                    model.thumbnail_images.full.oID=model.oID;
//                    model.thumbnail_images.thumbnail.oID=model.oID;
//                    model.thumbnail_images.medium.oID=model.oID;
//                    model.thumbnail_images.large.oID=model.oID;
//                    for (AttachmentModel *attachment in model.attachments) {
//                        attachment.images.oID=attachment.oID;
//                        attachment.images.full.oID=attachment.oID;
//                        attachment.images.thumbnail.oID=attachment.oID;
//                        attachment.images.medium.oID=attachment.oID;
//                        attachment.images.large.oID=attachment.oID;
//                    }
                        Post *post=[model saveToCore];
                        [post importValuesForKeysWithObject:model];
                        [posts addObject:post];
                }];
                if (completion){
                    completion(YES, nil,posts);
                }
            }];
        }
    }];
    [dataTask resume];
}

@end
