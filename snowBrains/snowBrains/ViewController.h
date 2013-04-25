//
//  ViewController.h
//  webapp
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
#import "MoreViewController.h"
#import "LeftMenuViewController.h"

@interface ViewController : UIViewController<UIWebViewDelegate,PullToRefreshViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,LeftMenuViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIImageView *loadBackground;
@property (strong, nonatomic) IBOutlet UIImageView *loadLogo;
@property (strong, nonatomic) IBOutlet UIImageView *loadFigure;
@property (strong, nonatomic) IBOutlet UIImageView *flakeAnimation;


@end
