//
//  LocationViewController.m
//  snowBrains
//
//  Created by Patrick on 13/04/15.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    //set border radius on visibility
    self.view.layer.cornerRadius = -1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentSizeForViewInPopover=CGSizeMake(53 , 100);
    self.view.layer.cornerRadius = 0;
}
- (IBAction)moreTap:(id)sender{
    if(!self.moreButton.isSelected)
        [self.moreButton setSelected:YES];
    MoreViewController* popoverView=[[MoreViewController alloc]init];
    
    UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController: popoverView];
    popover.popoverBackgroundViewClass=[CustomPopoverBackgroundView class];
    popover.passthroughViews=[[NSArray alloc]initWithObjects:self.view, nil];
    popover.delegate=self;
    popover.popoverLayoutMargins = UIEdgeInsetsMake(self.moreButton.frame.origin.x, self.moreButton.frame.origin.x, 0, 0);
    self.pop=popover;
    [self.pop presentPopoverFromRect:self.moreButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
