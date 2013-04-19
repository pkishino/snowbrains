//
//  VideoViewController.m
//  snowBrains
//
//  Created by Patrick on 13/04/16.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentSizeForViewInPopover=CGSizeMake(53 , 60);
}
-(IBAction)brainTap:(id)sender{
    [self deselect];
    if(!self.brainButton.isSelected)
        [self.brainButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/brainvideos/?app=1"]];
}
-(IBAction)nonBrainTap:(id)sender{
    [self deselect];
    if(!self.nonBrainButton.isSelected)
        [self.nonBrainButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/nonbrain/?app=1"]];
}
-(IBAction)trailerTap:(id)sender{
    [self deselect];
    if(!self.trailerButton.isSelected)
        [self.trailerButton setSelected:YES];
    [self.delegate loadpage:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/trailers/?app=1"]];
}

-(void)deselect{
    for(int i=212;i<215;i++){
        [((UIButton *)[self.view viewWithTag:i]) setSelected:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
