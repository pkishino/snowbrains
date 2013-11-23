//
//  Post.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachement, Author, Category, Comment, Image, Tag;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * comment_status;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * excerpt;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * likeID;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * thumbnail_size;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * title_plain;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *attachements;
@property (nonatomic, retain) Author *author;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) Image *thumbnail_images;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addAttachementsObject:(Attachement *)value;
- (void)removeAttachementsObject:(Attachement *)value;
- (void)addAttachements:(NSSet *)values;
- (void)removeAttachements:(NSSet *)values;

- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
