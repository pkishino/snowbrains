//
//  ViewController.h
//  webapp
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
#import "LeftMenuViewController.h"
#import "BookmarkViewController.h"
#import "AFNetworking.h"
#import <iAd/iAd.h>
#import "BurstlyBannerAdView.h"
#import "BurstlyBannerViewDelegate.h"
#import "Appirater.h"
#import "AppiraterDelegate.h"
#import "AppDelegate.h"



@interface ViewController : UIViewController<UIWebViewDelegate,PullToRefreshViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,LeftMenuViewControllerDelegate,UIActionSheetDelegate,ADBannerViewDelegate,MFMailComposeViewControllerDelegate,BurstlyBannerViewDelegate,AppiraterDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIImageView *loadBackground;
@property (strong, nonatomic) IBOutlet UIImageView *loadLogo;
@property (strong, nonatomic) IBOutlet UIImageView *loadFigure;
@property (strong, nonatomic) IBOutlet UIImageView *flakeAnimation;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)backwardTap:(id)sender;
- (IBAction)bookmarkTap:(id)sender;
- (IBAction)shareTap:(id)sender;
- (IBAction)forwardTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bookmarkButton;
-(id)init;
-(id)initWithForward:(BOOL)forward;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (nonatomic,retain) BurstlyBannerAdView *burstlyBanner;

@end
