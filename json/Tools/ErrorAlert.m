//
//  ErrorAlert.m
//  json
//
//  Created by Patrick Ziegler on 1/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "ErrorAlert.h"

@implementation ErrorAlert

+(id)errorAlert{
        static ErrorAlert *errorAlert=nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            errorAlert=[[self alloc]init];
        });
        return errorAlert;
}
+(void)postError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"error",nil) message:[NSString stringWithFormat:NSLocalizedString(@"An error occurred:%@",nil),error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];});
}
@end
