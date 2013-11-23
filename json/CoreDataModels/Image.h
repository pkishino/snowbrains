//
//  Image.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachement, ImageData, Post;

@interface Image : NSManagedObject

@property (nonatomic, retain) ImageData *full;
@property (nonatomic, retain) ImageData *large;
@property (nonatomic, retain) ImageData *medium;
@property (nonatomic, retain) ImageData *post_thumbnail;
@property (nonatomic, retain) ImageData *thumbnail;
@property (nonatomic, retain) NSSet *usedAttachement;
@property (nonatomic, retain) NSSet *usedPost;
@end

@interface Image (CoreDataGeneratedAccessors)

- (void)addUsedAttachementObject:(Attachement *)value;
- (void)removeUsedAttachementObject:(Attachement *)value;
- (void)addUsedAttachement:(NSSet *)values;
- (void)removeUsedAttachement:(NSSet *)values;

- (void)addUsedPostObject:(Post *)value;
- (void)removeUsedPostObject:(Post *)value;
- (void)addUsedPost:(NSSet *)values;
- (void)removeUsedPost:(NSSet *)values;

@end
