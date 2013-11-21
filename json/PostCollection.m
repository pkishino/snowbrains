//
//  PostCollection.m
//  json
//
//  Created by Patrick Ziegler on 4/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostCollection.h"
#import "PostObject.h"
#import "Post.h"

#define sLatestPosts [NSURL URLWithString:@"http://www.snowbrains.com/?json=get_recent_posts&dev=1&exclude=categories,tags,modified,status,slug,type"]

@implementation PostCollection

-(PostObject *)retrievePost:(NSString *)reference{
    Post *post = [Post MR_findFirstByAttribute:@"idTag" withValue:reference];
    return [[PostObject alloc]initWithPost:post];
}

-(NSArray*)retrieveLatestPosts{
    NSNumberFormatter *format= [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    NSMutableArray *allPosts=[NSMutableArray new];
    NSError *error=nil;
    NSData *data=[NSData dataWithContentsOfURL:sLatestPosts];
    if(data){
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *items=json[@"posts"];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if(![Post MR_findFirstByAttribute:@"idTag" withValue:reference]){
            PostObject *postObject=[[PostObject alloc] initWithDictionary:obj];
            //        NSLog(@"%@",item);
            [allPosts addObject:[NSDictionary dictionaryWithObject:postObject forKey:postObject.ID]];
            Post *post=[Post MR_createEntity];
            post.author=postObject.author;
            post.commentCount=postObject.commentCount;
            post.content=postObject.content;
            post.date=postObject.date;
            post.excerpt=postObject.excerpt;
            post.title=postObject.title;
            post.thumbnail=[NSString stringWithFormat:@"%@",postObject.thumbnail];
            post.idTag=[NSString stringWithFormat:@"%@",postObject.ID];
            post.postUrl=[NSString stringWithFormat:@"%@",postObject.postUrl];
            post.likeID=[NSString stringWithFormat:@"%@",postObject.likeID];
            }
        }];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return [Post MR_findAll];
}

@end
