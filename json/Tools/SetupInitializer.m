//
//  SetupInitializer.m
//  json
//
//  Created by Patrick Ziegler on 1/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "SetupInitializer.h"
#import <JSONModel.h>
#import <TestFlight.h>

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
    [TestFlight takeOff:@"c0b7b825-f506-4f0b-b73f-0d75286c3318"];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
    [DTCoreTextFontDescriptor asyncPreloadFontLookupTable];
    [FBProfilePictureView class];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [JSONModel setGlobalKeyMapper:[[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"objectDescription",@"id":@"oID"}]];

    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [[UIToolbar appearance]setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrainsTextColour"]]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
}
@end
