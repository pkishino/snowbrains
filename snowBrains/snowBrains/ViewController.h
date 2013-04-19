//
//  ViewController.h
//  webapp
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
#import "LocationViewController.h"
#import "MoreViewController.h"
#import "VideoViewController.h"
#import "CustomPopoverBackgroundView.h"

@interface ViewController : UIViewController<UIWebViewDelegate,PullToRefreshViewDelegate,UIPopoverControllerDelegate,MoreViewControllerDelegate,VideoViewControllerDelegate,LocationViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) UIPopoverController *pop;
@property (strong, nonatomic) LocationViewController *locationViewRef;
@property (strong, nonatomic) IBOutlet UIImageView *loadBackground;
@property (strong, nonatomic) IBOutlet UIImageView *loadFigure;
@property (strong, nonatomic) IBOutlet UIImageView *flakeAnimation;

- (IBAction)homeTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;

- (IBAction)locationTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;

- (IBAction)weatherTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *weatherButton;

- (IBAction)videoTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *videoButton;

- (IBAction)gearTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *gearButton;

- (IBAction)brainsTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *brainsButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
