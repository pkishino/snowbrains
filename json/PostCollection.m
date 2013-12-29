//
//  PostCollection.m
//  json
//
//  Created by Patrick Ziegler on 4/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostCollection.h"
#import "Post.h"
#import "Author.h"

@implementation PostCollection

+(id)postCollection{
    static PostCollection *postCollection=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        postCollection=[[self alloc]init];
    });
    return postCollection;
}
+(Post *)retrievePost:(NSNumber*)reference{
    return [Post findFirstByAttribute:@"oID" withValue:reference];
}
+(Post *)retrieveLatestPost{
    return [Post findFirstOrderedByAttribute:@"date" ascending:NO];
}

+(void)retrieveLatestPostsWithCompletion:(PostCompletionHandler)completion{
    [PostRetriever getLatestPostRequestWithCompletion:completion];
}
+(NSArray *)retrieveAllPosts{
    NSArray* posts=[PostCollection retrievePostsCount:10];
    if(!posts.count>0){
        [PostRetriever getLatestPostRequestWithCompletion:^(BOOL success, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PostsDownloaded" object:nil];
            }else{
                [ErrorAlert postError:error];
            }
        }];
        return [NSArray array];
    }else{
        return posts;
    }
}
+(NSArray*)retrievePostsAfter:(NSDate*)date{
    NSPredicate*pred=[NSPredicate predicateWithFormat:@"date>=%@",date];
    return [Post findAllWithPredicate:pred];
}

+(NSArray*)retrievePostsBefore:(NSDate *)date{
    NSPredicate*pred=[NSPredicate predicateWithFormat:@"date<=%@",date];
    NSArray* posts=[Post findAllWithPredicate:pred];
    if(!posts.count>1){
        NSDictionary *after=[NSDictionary dictionaryWithObject:[PostCollection getDateDictionary:date] forKey:@"before"];
        NSDictionary *complete=[NSDictionary dictionaryWithObjectsAndKeys:after,@"date_query", nil];
        [PostRetriever getPostsRequestWithParameters:complete withCompletion:^(BOOL success, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"OldPostsDownloaded" object:nil userInfo:[NSDictionary dictionaryWithObject:date forKey:@"date"]];
            }else{
                [ErrorAlert postError:error];
            }
        }];
        return [NSArray array];
    }else{
        return [NSMutableArray arrayWithArray:[Post findAllSortedBy:@"date" ascending:NO]];
    }
}

+(NSArray*)retrievePostsCount:(int)count{
    NSFetchRequest *request=[Post requestAllSortedBy:@"date" ascending:NO];
    [request setFetchLimit:count];
    return [Post executeFetchRequest:request];
}

+(NSArray*)retrievePostByCategory:(NSString*)categoryName{
    return nil;
}

+(NSArray*)retrievePostsByTag:(NSString *)tagName{
    return nil;
}

+(NSArray*)retrievePostsByAuthor:(NSString*)authorName{
    NSPredicate*pred=[NSPredicate predicateWithFormat:@"author.name=%@",authorName];
    return [Post findAllWithPredicate:pred];

}
+(NSDictionary*)getDateDictionary:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[dateFormatter stringFromDate:date];
    NSArray* dateParts=[dateString componentsSeparatedByString:@"-"];
    return [NSDictionary dictionaryWithObjectsAndKeys:dateParts[2],@"day",dateParts[1],@"month",dateParts[0],@"year", nil];
}

@end
