//
//  PostCollection.m
//  json
//
//  Created by Patrick Ziegler on 4/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostCollection.h"
#import "Post.h"

#define sLatestPosts [NSURL URLWithString:@"http://www.snowbrains.com/?json=get_recent_posts&dev=1&exclude=categories,tags,modified,status,slug,type"]

@implementation PostCollection

-(Post *)retrievePost:(NSString *)reference{
    Post *post=[self.postCollection valueForKey:reference];
    return post;
}

-(NSMutableOrderedSet*)retrieveLatestPosts{
    NSNumberFormatter *format= [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    NSMutableOrderedSet *allPosts=[NSMutableOrderedSet new];
    NSError *error=nil;
    NSData *data=[NSData dataWithContentsOfURL:sLatestPosts];
    if(data){
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *items=json[@"posts"];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Post *post=[[Post alloc] initWithDictionary:obj];
            //        NSLog(@"%@",item);
            [allPosts setV]
            [allPosts setValue:post forKey:post.ID];
        }];
    }
    if(self.postCollection){
        [self.postCollection unionOrderedSet:allPosts];
        return self.postCollection;
    }else{
        return allPosts;
    }
}

@end
