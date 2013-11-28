//
//  Attachment.h
//  json
//
//  Created by Patrick Ziegler on 27/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonInterface.h"

@class Image, Post;

@interface Attachment : CommonInterface

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * mime_type;
@property (nonatomic, retain) NSString * objectDescription;
@property (nonatomic, retain) NSNumber * parent;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Image *images;
@property (nonatomic, retain) Post *post;

@end
