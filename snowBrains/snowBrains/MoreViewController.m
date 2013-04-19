//
//  MoreViewController.m
//  snowBrains
//
//  Created by Patrick on 13/04/15.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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
    self.contentSizeForViewInPopover=CGSizeMake(53 , 120);
    self.view.layer.cornerRadius = 0;
}
-(IBAction)utahTap:(id)sender{
    [self deselect];
//    if(!self.utahButton.isSelected)
//        [self.utahButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/utah/?app=1"]];
    
}
-(IBAction)mammothTap:(id)sender{
    [self deselect];
//    if(!self.mammothButton.isSelected)
//        [self.mammothButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/mammoth/?app=1"]];
}
-(IBAction)pnwTap:(id)sender{
    [self deselect];
//    if(!self.pnwButton.isSelected)
//        [self.pnwButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/pacificnorthwest/?app=1"]];
}
-(IBAction)samericaTap:(id)sender{
    [self deselect];
//    if(!self.samericaButton.isSelected)
//        [self.samericaButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/southamerica/?app=1"]];
}
-(IBAction)japanTap:(id)sender{
    [self deselect];
//    if(!self.japanButton.isSelected)
//        [self.japanButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/japan/?app=1"]];
}
-(IBAction)alpsTap:(id)sender{
    [self deselect];
//    if(!self.alpsButton.isSelected)
//        [self.alpsButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/alps/?app=1"]];
}

-(void)deselect{
    for(int i=206;i<212;i++){
        [((UIButton *)[self.view viewWithTag:i]) setSelected:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
