//
//  Tag.h
//  json
//
//  Created by Patrick Ziegler on 27/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonInterface.h"

@class Post;

@interface Tag : CommonInterface

@property (nonatomic, retain) NSString * objectDescription;
@property (nonatomic, retain) NSNumber * post_count;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *posts;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
