//
//  ImageData.h
//  json
//
//  Created by Patrick Ziegler on 28/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image;

@interface ImageData : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSSet *usedFull;
@property (nonatomic, retain) NSSet *usedLarge;
@property (nonatomic, retain) NSSet *usedMedium;
@property (nonatomic, retain) NSSet *usedThumbnail;
@end

@interface ImageData (CoreDataGeneratedAccessors)

- (void)addUsedFullObject:(Image *)value;
- (void)removeUsedFullObject:(Image *)value;
- (void)addUsedFull:(NSSet *)values;
- (void)removeUsedFull:(NSSet *)values;

- (void)addUsedLargeObject:(Image *)value;
- (void)removeUsedLargeObject:(Image *)value;
- (void)addUsedLarge:(NSSet *)values;
- (void)removeUsedLarge:(NSSet *)values;

- (void)addUsedMediumObject:(Image *)value;
- (void)removeUsedMediumObject:(Image *)value;
- (void)addUsedMedium:(NSSet *)values;
- (void)removeUsedMedium:(NSSet *)values;

- (void)addUsedThumbnailObject:(Image *)value;
- (void)removeUsedThumbnailObject:(Image *)value;
- (void)addUsedThumbnail:(NSSet *)values;
- (void)removeUsedThumbnail:(NSSet *)values;

@end
