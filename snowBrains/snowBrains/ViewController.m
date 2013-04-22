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
    BOOL redirect;
    NSString *requestString;
    UIButton *backButton;
    UIButton *forwardButton;
}

@end

@implementation ViewController

- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return ((toInterfaceOrientation == UIInterfaceOrientationPortrait)|| (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll|UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown);
}
-(void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webview setDelegate:self];
    [self setupPullDownRefresh];
    [self setupAnimation];
    [self setupSwipe];
    [self.homeButton setSelected:YES];
    
    [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
}
-(void)loadWithURL:(NSURL *)url{
    [self.webview stopLoading];
    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    [self.webview loadRequest:snowbrains];
}
-(void)setupSwipe{
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backSwipe)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipeRecognizer.cancelsTouchesInView = YES;
    backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:[UIImage imageNamed:@"backwardSwipe"] forState:UIControlStateNormal];
    [self.webview addGestureRecognizer:leftSwipeRecognizer];
    [backButton addTarget:self action:@selector(backwardTap:) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame=CGRectMake(0, self.view.center.y, 41, 54);
    backButton.hidden=YES;
    [self.webview addSubview:backButton];
    
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(forwardSwipe)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipeRecognizer.cancelsTouchesInView = YES;
    [self.webview addGestureRecognizer:rightSwipeRecognizer];
    
    forwardButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:[UIImage imageNamed:@"forwardSwipe"] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(forwardTap:) forControlEvents:UIControlEventTouchUpInside];
//    forwardButton.frame=CGRectMake(self.view.frame.size.width-41, self.view.center.y, 41, 54);
    forwardButton.hidden=YES;
    [self.webview addSubview:forwardButton];
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
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(cancelPullToRefresh) userInfo:nil repeats:NO];
}
-(void)cancelPullToRefresh{
    [(UIWebView *)[self.view viewWithTag:999] stopLoading];
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.flakeAnimation.hidden=NO;
    [self setupAnimation];
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
    if(!redirect){
        if(error.code==kCFURLErrorNotConnectedToInternet){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Could not load the requested page, please check that you have Internet Access" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.flakeAnimation stopAnimating];
            self.flakeAnimation.hidden=YES;
            self.loadFigure.hidden=YES;
            self.loadBackground.hidden=YES;
            [self.webview stopLoading];
            [(PullToRefreshView *)[self.view viewWithTag:998]finishedLoading];
        }else if(!error.code==kCFURLErrorCancelled)
            [self.webview goBack];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    redirect=NO;
    requestString=[NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"%@ navtype: %d",requestString,navigationType);
    //if navigationtype is 0 (link clicked) then check, otherwise ignore (keep loading)(type 5)
    //if the request is to somewhere in snowbrains then copy out the request, attach /?app=1 to it if not already and then send that request instead
    if(navigationType==UIWebViewNavigationTypeLinkClicked){
        if([requestString rangeOfString:@"http://www.snowbrains.com"].location==NSNotFound&&[requestString rangeOfString:@"http://snowbrains.com"].location==NSNotFound){
            //if the request is to outside of snowbrains then ask if user wants to open in safari
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"External site" message:@"The requested site is outside of Snowbrains, please press OK to load with default Browser" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
            [alert show];
            return NO;
        }else if ([requestString rangeOfString:@"?app=1"].location==NSNotFound){
            NSURL *redirectTo=[NSURL URLWithString:[NSString stringWithFormat:@"%@?app=1",requestString]];
            [self loadWithURL:redirectTo];
            redirect=YES;
            return NO;
        }
    }
    //if request is a mailto request then handle that
    
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( buttonIndex == 1 ) [[UIApplication sharedApplication]openURL:[NSURL URLWithString:requestString]];
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
    [self dismissAndDeselect];
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
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)backSwipe{
    if(backButton.isHidden){
        backButton.frame=CGRectMake(0, self.webview.center.y-100, 41, 54);
        backButton.hidden=NO;
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(backSwipe) userInfo:nil repeats:NO];
    }else
        backButton.hidden=YES;
}
-(void)forwardSwipe{
    if(forwardButton.isHidden){
        forwardButton.frame=CGRectMake(self.webview.frame.size.width-41, self.webview.center.y-100, 41, 54);
        forwardButton.hidden=NO;
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(forwardSwipe) userInfo:nil repeats:NO];
    }else
        forwardButton.hidden=YES;
}
-(IBAction)backwardTap:(id)sender{
    [self.webview goBack];
}
-(IBAction)forwardTap:(id)sender{
    [self.webview goForward];
}

@end
