//
//  PostCollection.h
//  json
//
//  Created by Patrick Ziegler on 4/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostRetriever.h"
@class Post;

@interface PostCollection : NSObject
+(id)postCollection;

+(Post*)retrievePost:(NSNumber*)reference;

+(void)retrieveLatestPostsWithCompletion:(PostCompletionHandler)completion;

+(Post*)retrieveLatestPost;

+(NSArray*)retrieveAllPosts;

+(NSArray*)retrievePostsAfter:(NSDate*)date;

+(NSArray*)retrievePostsBefore:(NSDate *)date;

+(NSArray*)retrievePostsCount:(int)count;

+(NSArray*)retrievePostByCategory:(NSString*)categoryName;

+(NSArray*)retrievePostsByTag:(NSString *)tagName;

+(NSArray*)retrievePostsByAuthor:(NSString*)authorName;



@end
