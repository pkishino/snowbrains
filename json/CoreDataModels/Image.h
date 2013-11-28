//
//  Image.h
//  json
//
//  Created by Patrick Ziegler on 28/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonInterface.h"

@class Attachment, ImageData, Post;

@interface Image : CommonInterface

@property (nonatomic, retain) ImageData *full;
@property (nonatomic, retain) ImageData *large;
@property (nonatomic, retain) ImageData *medium;
@property (nonatomic, retain) ImageData *thumbnail;
@property (nonatomic, retain) NSSet *usedAttachment;
@property (nonatomic, retain) NSSet *usedPost;
@end

@interface Image (CoreDataGeneratedAccessors)

- (void)addUsedAttachmentObject:(Attachment *)value;
- (void)removeUsedAttachmentObject:(Attachment *)value;
- (void)addUsedAttachment:(NSSet *)values;
- (void)removeUsedAttachment:(NSSet *)values;

- (void)addUsedPostObject:(Post *)value;
- (void)removeUsedPostObject:(Post *)value;
- (void)addUsedPost:(NSSet *)values;
- (void)removeUsedPost:(NSSet *)values;

@end
