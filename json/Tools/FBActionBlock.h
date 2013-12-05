//
//  FBActionBlock.h
//  json
//
//  Created by Patrick Ziegler on 30/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK.h>

typedef void (^FBCompletionHandler)(NSError *error,id result);

@interface FBActionBlock : NSObject
+(id)fbActionBlock;
+(void)runFaceBookBlock:(void(^)(void))completion;
+(void)performFBLikeonItem:(NSString*)url withCompletion:(FBCompletionHandler)completion;
+(void)performFBUnLikeonItem:(NSString*)likeID withCompletion:(FBCompletionHandler)completion;

@end
