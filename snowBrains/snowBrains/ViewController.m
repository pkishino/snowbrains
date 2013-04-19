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
    return ((toInterfaceOrientation == UIInterfaceOrientationPortrait)|| (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait |  UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
}
-(void)viewWillAppear:(BOOL)animated{
    [self setupAnimation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webview setDelegate:self];
    [self setupPullDownRefresh];
    
    [self.homeButton setSelected:YES];
    
    [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
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
    if([self.pop isPopoverVisible])
        [self.pop dismissPopoverAnimated:YES];
    if(self.locationViewRef.pop){
        if([self.locationViewRef.pop isPopoverVisible])
            [self.locationViewRef.pop dismissPopoverAnimated:YES];
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString=[NSString stringWithFormat:@"Request: %@ and Nav type: %d",request,navigationType];
    NSLog(@"%@",requestString);
    //if navigationtype is 0 (link clicked) then check, otherwise ignore (keep loading)(type 5)
    //if the request is to somewhere in snowbrains then copy out the request, attach /?app=1 to it if not already and then send that request instead
    //if request is a mailto request then handle that
    
    
    //if the request is to outside of snowbrains then ask if user wants to open in safari
    
    //if(request )
    return YES;
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
    if(!self.homeButton.isSelected){
        [self dismissAndDeselect];
        [self.homeButton setSelected:YES];
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
    }
}
- (IBAction)locationTap:(id)sender {
    if(!self.locationButton.isSelected){
        [self dismissAndDeselect];
        [self.locationButton setSelected:YES];
        //[self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/?app=1"]];
        LocationViewController* popoverView=[[LocationViewController alloc]init];
        popoverView.delegate=self;
        popoverView.mainViewRef=self.view;
        self.locationViewRef=popoverView;
        UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController: popoverView];
        popover.popoverBackgroundViewClass=[CustomPopoverBackgroundView class];
        popover.passthroughViews=[[NSArray alloc]initWithObjects:self.view, nil];
        popover.delegate=self;
        popover.popoverLayoutMargins = UIEdgeInsetsMake(self.locationButton.frame.origin.x, self.locationButton.frame.origin.x, 0, 0);
        self.pop=popover;
        [self.pop presentPopoverFromRect:self.locationButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else{
        if([self.pop isPopoverVisible])
            [self.pop dismissPopoverAnimated:YES];
        if(self.locationViewRef.pop){
            if([self.locationViewRef.pop isPopoverVisible])
                [self.locationViewRef.pop dismissPopoverAnimated:YES];
        }
    }
}
- (IBAction)weatherTap:(id)sender{
    if(!self.weatherButton.isSelected){
        [self dismissAndDeselect];
        [self.weatherButton setSelected:YES];
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/weather/?app=1"]];
    }
}
- (IBAction)videoTap:(id)sender{
    if(!self.videoButton.isSelected){
        [self dismissAndDeselect];        
        [self.videoButton setSelected:YES];
        //[self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/?app=1"]];
        VideoViewController* popoverView=[[VideoViewController alloc]init];
        popoverView.delegate=self;
        UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController: popoverView];
        popover.popoverBackgroundViewClass=[CustomPopoverBackgroundView class];
        popover.delegate=self;
        popover.popoverLayoutMargins = UIEdgeInsetsMake(self.videoButton.frame.origin.x, self.videoButton.frame.origin.x, 0, 0);
        popover.passthroughViews=[[NSArray alloc]initWithObjects:self.view, nil];
        self.pop=popover;
        [self.pop presentPopoverFromRect:self.videoButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else{
        if([self.pop isPopoverVisible])
            [self.pop dismissPopoverAnimated:YES];
    }
    
}
- (IBAction)gearTap:(id)sender{
    if(!self.gearButton.isSelected){
        [self dismissAndDeselect];        
        [self.gearButton setSelected:YES];
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/gear/?app=1"]];
    }
}
- (IBAction)brainsTap:(id)sender{
    if(!self.brainsButton.isSelected){
        [self dismissAndDeselect];
        [self.brainsButton setSelected:YES];
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/brains/?app=1"]];
    }
}
-(void)dismissAndDeselect{
    if([self.pop isPopoverVisible])
        [self.pop dismissPopoverAnimated:YES];
    if(self.locationViewRef.pop){
        if([self.locationViewRef.pop isPopoverVisible])
            [self.locationViewRef.pop dismissPopoverAnimated:YES];
    }
    for(int i=101;i<107;i++){
        [((UIButton *)[self.view viewWithTag:i]) setSelected:NO];
    }
}
-(void)loadpage:(NSURL *)url{
    [self loadWithURL:url];
}
-(void)setupAnimation{
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    fullRotation.duration = 5.0;
    fullRotation.repeatCount = HUGE_VALF;
    [self.flakeAnimation.layer addAnimation:fullRotation forKey:@"flakeAnimation"];
}
-(void)setupImageAnimation{
    
}

@end
