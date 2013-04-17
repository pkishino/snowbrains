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
#import "VideoViewController.h"
#import "CustomPopoverBackgroundView.h"

@interface ViewController : UIViewController<UIWebViewDelegate,PullToRefreshViewDelegate,UIPopoverControllerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) UIPopoverController *pop;

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




@end
