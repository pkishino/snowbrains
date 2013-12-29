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
             requestNewPublishPermissions:@[@"publish_actions"]
             defaultAudience:FBSessionDefaultAudienceFriends
             completionHandler:^(FBSession *session, NSError *error) {
                 if(!error&&completion){
                     completion();
                 }else{
                     [ErrorAlert postError:error];
                 }
             }];
        }else{
            completion();
        }
    }else{
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if(!error&&completion&&status==FBSessionStateOpen){
                completion();
            }else{
                [ErrorAlert postError:error];
            }
        }];
    }
}
+(void)performFBLikeonItem:(NSString*)url withCompletion:(FBCompletionHandler)completion{
    [FBActionBlock runFaceBookBlock:^{
            NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
            action[@"object"] = [NSString stringWithFormat:@"%@",url];
            
            [FBRequestConnection startForPostWithGraphPath:@"me/og.likes"
                                               graphObject:action
                                         completionHandler:^(FBRequestConnection *connection,
                                                             id result,
                                                             NSError *error) {
                                                 completion(error,result);
                                         }];
    }];
    
}
+(void)performFBUnLikeonItem:(NSString *)likeID withCompletion:(FBCompletionHandler)completion{
    [FBActionBlock runFaceBookBlock:^{
        [FBRequestConnection startWithGraphPath:likeID
                                     parameters:nil
                                     HTTPMethod:@"DELETE"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                                  completion(error,result);
                              }];
    }];
}
@end