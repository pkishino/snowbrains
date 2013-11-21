//
//  Post.m
//  json
//
//  Created by Patrick Ziegler on 3/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostObject.h"


@implementation PostObject{
    NSDateFormatter *dateFormatter;
}
-(id)initWithDictionary:(NSDictionary *)dictionary{
    if(self =[self init]){
        dateFormatter=[NSDateFormatter new];
        [dateFormatter setDateFormat:@"yy/MM/dd"];
        [self setID:dictionary[@"id"]];
        [self setTitle:dictionary[@"title"]];
    
        [self setDate:[dateFormatter dateFromString:dictionary[@"date"]]];
        [self setAuthor:dictionary[@"author"][@"nickname"]];
        [self setExcerpt:dictionary[@"excerpt"]];
        
        [self setCommentCount:dictionary[@"comment_count"]];
        [self setThumbnail:[NSURL URLWithString:dictionary[@"thumbnail_images"][@"medium"][@"url"]]];
        [self setContent:dictionary[@"content"]];
        
        [self setAttachments:dictionary[@"attachments"]];
        [self setPostUrl:[NSURL URLWithString:dictionary[@"url"]]];
    }
    return self;
}

-(id)initWithPost:(Post *)post{
    if (self=[self init]) {
        [self setID:post.idTag];
        [self setTitle:post.title];
        
        [self setDate:post.date];
        [self setAuthor:post.author];
        [self setExcerpt:post.excerpt];
        
        [self setCommentCount:post.commentCount];
        [self setThumbnail:[NSURL URLWithString:post.thumbnail]];
        [self setContent:post.content];
        
        [self setPostUrl:[NSURL URLWithString:post.postUrl]];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    PostObject *newPost=[PostObject new];
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
