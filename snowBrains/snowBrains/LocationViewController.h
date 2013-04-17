//
//  LocationViewController.h
//  snowBrains
//
//  Created by Patrick on 13/04/15.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MoreViewController.h"
#import "CustomPopoverBackgroundView.h"

@interface LocationViewController : UIViewController<UIPopoverControllerDelegate>

@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) UIPopoverController *pop;

- (IBAction)squawTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *squawButton;

- (IBAction)jacksonTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *jacksonButton;

- (IBAction)whistlerTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *whistlerButton;

- (IBAction)alaskaTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *alaskaButton;

- (IBAction)moreTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;

@end

@protocol LocationViewControllerDelegate <NSObject>

@required
-(void)loadpage:(NSURL *)url;

@end

