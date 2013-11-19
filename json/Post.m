//
//  Post.m
//  json
//
//  Created by Patrick Ziegler on 3/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "Post.h"


@implementation Post
-(id)initWithDictionary:(NSDictionary *)dictionary{
    if(self =[self init]){
        [self setID:dictionary[@"id"]];
        [self setTitle:dictionary[@"title"]];
    
        [self setDate:dictionary[@"date"]];
        [self setAuthor:dictionary[@"author"][@"nickname"]];
        [self setExcerpt:dictionary[@"excerpt"]];
        
        [self setCommentCount:dictionary[@"comment_count"]];
        [self setThumbnail:[NSURL URLWithString:dictionary[@"thumbnail_images"][@"medium"][@"url"]]];
        [self setContent:dictionary[@"content"]];
        
//        [self setCategory:dictionary[@"categories"][0][@"slug"]];
        [self setAttachments:dictionary[@"attachments"]];
        [self setPostUrl:[NSURL URLWithString:dictionary[@"url"]]];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    Post *newPost=[Post new];
    [newPost setID:[self ID]];
    [newPost setTitle:[self title]];
    [newPost setDate:[self date]];
    [newPost setAuthor:[self author]];
    [newPost setExcerpt:[self excerpt]];
    [newPost setCommentCount:[self commentCount]];
    [newPost setThumbnail:[self thumbnail]];
    [newPost setContent:[self content]];
    return newPost;
}
@end
