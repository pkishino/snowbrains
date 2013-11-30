//
//  FBActionBlock.h
//  json
//
//  Created by Patrick Ziegler on 30/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK.h>
#import "Post.h"

typedef void (^FBCompletionHandler)(NSError *error,id result);

@interface FBActionBlock : NSObject
+(id)fbActionBlock;
+(void)runFaceBookBlock:(void(^)(void))completion;
+(void)performFBLike:(BOOL)like onItem:(Post*)post withCompletion:(FBCompletionHandler)completion;

@end
