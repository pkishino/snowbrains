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

@property (strong, nonatomic) UIPopoverController *pop;

- (IBAction)moreTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@end
