//
//  ViewController.h
//  webapp
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
@interface ViewController : UIViewController<UIWebViewDelegate,PullToRefreshViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end
