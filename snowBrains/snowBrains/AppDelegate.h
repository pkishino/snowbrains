//
//  AppDelegate.h
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSArray *globalData;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIWebViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain,nonatomic) UIWebView *preLoader;

@end
