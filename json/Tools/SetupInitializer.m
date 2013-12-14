//
//  SetupInitializer.m
//  json
//
//  Created by Patrick Ziegler on 1/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "SetupInitializer.h"
#import <JSONModel.h>

@implementation SetupInitializer

+(id)setupInitializer{
    static SetupInitializer *setupInitializer=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        setupInitializer=[[self alloc]init];
    });
    return setupInitializer;
}
+(void)setup{
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [DTCoreTextFontDescriptor asyncPreloadFontLookupTable];
    [FBProfilePictureView class];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [JSONModel setGlobalKeyMapper:[[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"objectDescription",@"id":@"oID"}]];
    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [[UIToolbar appearance]setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrainsTextColour"]]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
}
@end
