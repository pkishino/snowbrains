//
//  FBActionBlock.m
//  json
//
//  Created by Patrick Ziegler on 30/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "FBActionBlock.h"

@implementation FBActionBlock
+(id)fbActionBlock{
    static FBActionBlock *fbActionBlock=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        fbActionBlock=[[self alloc]init];
    });
    return fbActionBlock;
}
+(void)runFaceBookBlock:(void (^)(void))completion{
    if([[FBSession activeSession]isOpen]){
        if ([FBSession.activeSession.permissions
             indexOfObject:@"publish_actions"] == NSNotFound) {
            [FBSession.activeSession
             requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
             defaultAudience:FBSessionDefaultAudienceFriends
             completionHandler:^(FBSession *session, NSError *error) {
                 if(!error&&completion){
                     completion();
                 }
             }];
        }
    }else{
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if(!error&&completion&&status==FBSessionStateOpen){
                completion();
            }
        }];
    }
}
+(void)performFBLike:(BOOL)like onItem:(Post*)post withCompletion:(FBCompletionHandler)completion{
    if(like){
        NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
        action[@"object"] = [NSString stringWithFormat:@"%@",post.url];
        
        [FBRequestConnection startForPostWithGraphPath:@"me/og.likes"
                                           graphObject:action
                                     completionHandler:^(FBRequestConnection *connection,
                                                         id result,
                                                         NSError *error) {
                                         completion(error,result);}];
    }else{
        [FBRequestConnection startWithGraphPath:post.likeID.stringValue
                                     parameters:nil
                                     HTTPMethod:@"DELETE"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                                  completion(error,result);}];
    }
}
@end
