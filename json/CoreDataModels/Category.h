//
//  Category.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * post_count;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * category_description;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * parent;
@property (nonatomic, retain) NSSet *posts;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
