//
//  PostCollection.m
//  json
//
//  Created by Patrick Ziegler on 4/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostCollection.h"
#import "Post.h"


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

+(void)retrieveLatestPostsWithCompletion:(PostCompletionHandler)completion{
    [PostRetriever getLatestPostRequestWithCompletion:completion];
}
+(NSArray *)retrieveAllPosts{
    return [Post findAllSortedBy:@"date" ascending:NO];
}
+(NSArray*)retrievePostsAfter:(NSDate*)date{
    
}

+(NSArray*)retrievePostsBefore:(NSDate *)date{
    
}

+(NSArray*)retrievePostsCount:(int)count{
    
}

+(NSArray*)retrievePostByCategory:(NSString*)categoryName{
    
}

+(NSArray*)retrievePostsByTag:(NSString *)tagName{
    
}

+(NSArray*)retrievePostsByAuthor:(NSString*)authorName{
    
}

@end
