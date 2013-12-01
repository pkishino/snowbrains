//
//  ErrorAlert.h
//  json
//
//  Created by Patrick Ziegler on 1/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorAlert : NSObject
+(id)errorAlert;
+(void)postError:(NSError*)error;

@end
