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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return ((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)|| (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webview setDelegate:self];
    [self setupPullDownRefresh];

    [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
    
    [self.homeButton setSelected:YES];
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    fullRotation.duration = 1.0;
    fullRotation.repeatCount = 100;
    [self.flakeAnimation.layer addAnimation:fullRotation forKey:@"spinner"];
    //[self.view addSubview:self.flakeAnimation];
    //spinner.tag = SPINNY_TAG;
}
-(void)loadWithURL:(NSURL *)url{
    //NSURL *url = [NSURL URLWithString:@"http://www.snowbrains.com/?app=1"];
    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [self.webview loadRequest:snowbrains];
}
-(void)setupPullDownRefresh{
    //setup the pulldownrefresh view
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
-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.flakeAnimation.hidden=NO;
    [self.flakeAnimation startAnimating];
    if(!self.loadFigure.isHidden){
        self.loadFigure.hidden=NO;
        self.loadBackground.hidden=NO;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.flakeAnimation stopAnimating];
    self.flakeAnimation.hidden=YES;
    self.loadFigure.hidden=YES;
    self.loadBackground.hidden=YES;
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebview:nil];
    [self setLocationButton:nil];
    [self setLoadingIndicator:nil];
    [self setLoadBackground:nil];
    [self setLoadFigure:nil];
    [self setFlakeAnimation:nil];
    [super viewDidUnload];
}
- (IBAction)homeTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.homeButton.isSelected)
        [self.homeButton setSelected:YES];
    [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
}
- (IBAction)locationTap:(id)sender {
    [self dismissAndDeselect];
    if(!self.locationButton.isSelected)
       [self.locationButton setSelected:YES];
    //[self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/?app=1"]];
    LocationViewController* popoverView=[[LocationViewController alloc]init];
    popoverView.delegate=self;
    
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
     [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/weather/?app=1"]];
}
- (IBAction)videoTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.videoButton.isSelected)
        [self.videoButton setSelected:YES];
     [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/?app=1"]];
    VideoViewController* popoverView=[[VideoViewController alloc]init];
    popoverView.delegate=self;
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
     [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/gear/?app=1"]];
}
- (IBAction)brainsTap:(id)sender{
    [self dismissAndDeselect];
    if(!self.brainsButton.isSelected)
        [self.brainsButton setSelected:YES];
     [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/brains/?app=1"]];
}
-(void)dismissAndDeselect{
    if([self.pop isPopoverVisible])
        [self.pop dismissPopoverAnimated:YES];
    for(int i=101;i<107;i++){
        [((UIButton *)[self.view viewWithTag:i]) setSelected:NO];
    }
}
-(void)loadpage:(NSURL *)url{
    [self loadWithURL:url];
}

@end
