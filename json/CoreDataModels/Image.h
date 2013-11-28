//
//  Image.h
//  json
//
//  Created by Patrick Ziegler on 27/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonInterface.h"

@class Attachment, ImageData, Post;

@interface Image : CommonInterface

@property (nonatomic, retain) NSSet *full;
@property (nonatomic, retain) NSSet *large;
@property (nonatomic, retain) NSSet *medium;
@property (nonatomic, retain) NSSet *thumbnail;
@property (nonatomic, retain) NSSet *usedAttachment;
@property (nonatomic, retain) NSSet *usedPost;
@end

@interface Image (CoreDataGeneratedAccessors)

- (void)addFullObject:(ImageData *)value;
- (void)removeFullObject:(ImageData *)value;
- (void)addFull:(NSSet *)values;
- (void)removeFull:(NSSet *)values;

- (void)addLargeObject:(ImageData *)value;
- (void)removeLargeObject:(ImageData *)value;
- (void)addLarge:(NSSet *)values;
- (void)removeLarge:(NSSet *)values;

- (void)addMediumObject:(ImageData *)value;
- (void)removeMediumObject:(ImageData *)value;
- (void)addMedium:(NSSet *)values;
- (void)removeMedium:(NSSet *)values;

- (void)addThumbnailObject:(ImageData *)value;
- (void)removeThumbnailObject:(ImageData *)value;
- (void)addThumbnail:(NSSet *)values;
- (void)removeThumbnail:(NSSet *)values;

- (void)addUsedAttachmentObject:(Attachment *)value;
- (void)removeUsedAttachmentObject:(Attachment *)value;
- (void)addUsedAttachment:(NSSet *)values;
- (void)removeUsedAttachment:(NSSet *)values;

- (void)addUsedPostObject:(Post *)value;
- (void)removeUsedPostObject:(Post *)value;
- (void)addUsedPost:(NSSet *)values;
- (void)removeUsedPost:(NSSet *)values;

@end
