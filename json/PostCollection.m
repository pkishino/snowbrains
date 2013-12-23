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
    return [Post findAllSortedBy:@"date" ascending:NO];
}
+(NSArray*)retrievePostsAfter:(NSDate*)date{
    NSPredicate*pred=[NSPredicate predicateWithFormat:@"date>=%@",date];
    return [Post findAllWithPredicate:pred];
}

+(NSArray*)retrievePostsBefore:(NSDate *)date{
    NSPredicate*pred=[NSPredicate predicateWithFormat:@"date<=%@",date];
    return [Post findAllWithPredicate:pred];
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

@end
