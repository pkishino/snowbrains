//
//  MyShareKitConfig.m
//  mobileBrains
//
//  Created by Patrick on 13/05/09.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "MyShareKitConfig.h"

@implementation MyShareKitConfig
- (NSString*)appName {
	return @"Snowbrains iPhone";
}

- (NSString*)appURL {
	return @"http://www.snowbrains.com";
}
- (NSString*)facebookAppId {
	return @"306955309438401";
}
- (NSNumber*)forcePreIOS6FacebookPosting {
	return [NSNumber numberWithBool:true];
}

@end
