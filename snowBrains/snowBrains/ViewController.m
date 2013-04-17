//
//  ViewController.m
//  webapp
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "ViewController.h"
@interface UIPopoverController (overrides)
+ (BOOL)_popoversDisabled;
@end

@implementation UIPopoverController (overrides)

+ (BOOL)_popoversDisabled { return NO;
}

@end

@interface ViewController (){
    UIScrollView *currentScrollView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPullDownRefresh];

    NSURL *url = [NSURL URLWithString:@"http://www.snowbrains.com/?app=1"];
    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    [self.webview loadRequest:snowbrains];
    
    [self.homeButton setSelected:YES];
}
-(void)setupPullDownRefresh{
    //setup the pulldownrefresh view
    [self.webview setDelegate:self];
    self.webview.tag=999;
    for(UIView *subView in self.webview.subviews){
        if([subView isKindOfClass:[UIScrollView class]]){
            currentScrollView=(UIScrollView *)subView;
            currentScrollView.delegate=(id)self;
        }
    }
    PullToRefreshView *pull=[[PullToRefreshView alloc]initWithScrollView:currentScrollView];
    [pull setDelegate:self];
    pull.tag=998;
    [currentScrollView addSubview:pull];
}
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [(UIWebView *)[self.view viewWithTag:999] reload];
}
- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebview:nil];
    [self setLocationButton:nil];
    [super viewDidUnload];
}
- (IBAction)homeTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.homeButton.isSelected)
        [self.homeButton setSelected:YES];
}
- (IBAction)locationTap:(id)sender {
    [self dismissAndDeselect];
    if(!self.locationButton.isSelected)
       [self.locationButton setSelected:YES];
    LocationViewController* popoverView=[[LocationViewController alloc]init];
    
    UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController: popoverView];
    popover.popoverBackgroundViewClass=[CustomPopoverBackgroundView class];
    popover.passthroughViews=[[NSArray alloc]initWithObjects:self.view, nil];
    popover.delegate=self;
    popover.popoverLayoutMargins = UIEdgeInsetsMake(self.locationButton.frame.origin.x, self.locationButton.frame.origin.x, 0, 0);
    self.pop=popover;
    [self.pop presentPopoverFromRect:self.locationButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
- (IBAction)weatherTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.weatherButton.isSelected)
        [self.weatherButton setSelected:YES];
}
- (IBAction)videoTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.videoButton.isSelected)
        [self.videoButton setSelected:YES];
    VideoViewController* popoverView=[[VideoViewController alloc]init];
    
    UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController: popoverView];
    popover.popoverBackgroundViewClass=[CustomPopoverBackgroundView class];
    popover.delegate=self;
    popover.popoverLayoutMargins = UIEdgeInsetsMake(self.videoButton.frame.origin.x, self.videoButton.frame.origin.x, 0, 0);
    popover.passthroughViews=[[NSArray alloc]initWithObjects:self.view, nil];
    self.pop=popover;
    [self.pop presentPopoverFromRect:self.videoButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}
- (IBAction)gearTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.gearButton.isSelected)
        [self.gearButton setSelected:YES];
}
- (IBAction)brainsTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.brainsButton.isSelected)
        [self.brainsButton setSelected:YES];
}
-(void)dismissAndDeselect{
    if([self.pop isPopoverVisible])
        [self.pop dismissPopoverAnimated:YES];
    for(int i=101;i<107;i++){
        [((UIButton *)[self.view viewWithTag:i]) setSelected:NO];
    }
}

@end
