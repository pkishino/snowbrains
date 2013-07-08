//
//  MoreViewController.h
//  snowBrains
//
//  Created by Patrick on 13/04/15.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MoreViewController : UIViewController

@property (nonatomic, assign) id delegate;
- (IBAction)utahTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *utahButton;

- (IBAction)mammothTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *mammothButton;

- (IBAction)pnwTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *pnwButton;

- (IBAction)samericaTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *samericaButton;

- (IBAction)japanTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *japanButton;

- (IBAction)alpsTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *alpsButton;


@end
@protocol MoreViewControllerDelegate <NSObject>

@required
-(void)loadpage:(NSURL *)url;

@end
