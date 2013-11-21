//
//  Post.h
//  json
//
//  Created by Patrick Ziegler on 19/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * excerpt;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * idTag;
@property (nonatomic, retain) NSString * postUrl;
@property (nonatomic, retain) NSString * likeID;

@end
