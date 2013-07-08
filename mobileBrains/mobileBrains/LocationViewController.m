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
- (IBAction)squawTap:(id)sender{
    [self dismissAndDeselect];
//    if(!self.squawButton.isSelected)
//        [self.squawButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/squaw/?app=1"]];
    
}
- (IBAction)jacksonTap:(id)sender{
    [self dismissAndDeselect];
//    if(!self.jacksonButton.isSelected)
//        [self.jacksonButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/jackson/?app=1"]];
    
}
- (IBAction)whistlerTap:(id)sender{
    [self dismissAndDeselect];
//    if(!self.whistlerButton.isSelected)
//        [self.whistlerButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/whistler/?app=1"]];
    
}
- (IBAction)alaskaTap:(id)sender{
    [self dismissAndDeselect];
//    if(!self.alaskaButton.isSelected)
//        [self.alaskaButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/alaska/?app=1"]];
    
}

- (IBAction)moreTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.moreButton.isSelected)
        [self.moreButton setSelected:YES];
    MoreViewController* popoverView=[[MoreViewController alloc]init];
    popoverView.delegate=self.delegate;
    UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController: popoverView];
    popover.popoverBackgroundViewClass=[CustomPopoverBackgroundView class];
    popover.passthroughViews=[[NSArray alloc]initWithObjects:self.view,self.mainViewRef, nil];
    popover.delegate=self;
    popover.popoverLayoutMargins = UIEdgeInsetsMake(self.moreButton.frame.origin.x, self.moreButton.frame.origin.x, 0, 0);
    popover.contentViewController.view.tag=666;
    self.pop=popover;
    [self.pop presentPopoverFromRect:self.moreButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}
-(void)dismissAndDeselect{
    if([self.pop isPopoverVisible])
        [self.pop dismissPopoverAnimated:YES];
    for(int i=201;i<206;i++){
        [((UIButton *)[self.view viewWithTag:i]) setSelected:NO];
    }
    //[((UIView *)[self.view viewWithTag:666])]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
