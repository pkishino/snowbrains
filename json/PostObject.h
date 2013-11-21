//
//  Post.h
//  json
//
//  Created by Patrick Ziegler on 3/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface PostObject : NSObject<NSCopying>

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *excerpt;
@property(nonatomic,strong)NSNumber *commentCount;
@property(nonatomic,strong)NSURL *thumbnail;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSArray *attachments;
@property(nonatomic,strong)NSURL *postUrl;
@property(nonatomic,strong)NSString *likeID;


-(id)initWithDictionary:(NSDictionary*)dictionary;
-(id)initWithPost:(Post *)post;

@end
