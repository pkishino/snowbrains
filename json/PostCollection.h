//
//  PostCollection.h
//  json
//
//  Created by Patrick Ziegler on 4/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OldPost;

@interface PostCollection : NSObject
@property (nonatomic,strong)NSArray* postCollection;

-(OldPost*)retrievePost:(NSString*)reference;

-(NSArray*)retrieveLatestPosts;

@end
