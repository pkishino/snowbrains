//
//  Author.h
//  json
//
//  Created by Patrick Ziegler on 27/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonInterface.h"

@class Comment, Post;

@interface Author : CommonInterface

@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * objectDescription;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *posts;
@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
