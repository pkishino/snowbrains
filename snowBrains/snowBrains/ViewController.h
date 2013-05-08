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

@interface ViewController : UIViewController<UIWebViewDelegate,PullToRefreshViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,LeftMenuViewControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIImageView *loadBackground;
@property (strong, nonatomic) IBOutlet UIImageView *loadLogo;
@property (strong, nonatomic) IBOutlet UIImageView *loadFigure;
@property (strong, nonatomic) IBOutlet UIImageView *flakeAnimation;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)backwardTap:(id)sender;
- (IBAction)shareTap:(id)sender;
- (IBAction)forwardTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
-(id)initWithForward:(BOOL)forward;

@end
