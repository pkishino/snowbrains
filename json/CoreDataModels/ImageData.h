//
//  ImageData.h
//  json
//
//  Created by Patrick Ziegler on 27/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonInterface.h"

@class Image;

@interface ImageData : CommonInterface

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) Image *usedFull;
@property (nonatomic, retain) Image *usedLarge;
@property (nonatomic, retain) Image *usedMedium;
@property (nonatomic, retain) Image *usedThumbnail;

@end
