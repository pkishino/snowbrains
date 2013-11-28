//
//  Comment.h
//  json
//
//  Created by Patrick Ziegler on 27/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonInterface.h"

@class Author, Post;

@interface Comment : CommonInterface

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * parent;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Author *author;
@property (nonatomic, retain) Post *post;

@end
