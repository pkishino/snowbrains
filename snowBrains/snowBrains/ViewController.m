//
//  ViewController.m
//  webapp
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "ViewController.h"
#import "MFSideMenu.h"
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
    UIImageView * backBar;
}

@end

@implementation ViewController

#pragma mark -
#pragma mark - View setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webview setDelegate:self];
    [self setupPullDownRefresh];
    [self setupAnimation];
    [self setupSwipe];
    [self setupSideMenu];
    [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
}
-(void)loadWithURL:(NSURL *)url{
    [self.webview stopLoading];
    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    [self.webview loadRequest:snowbrains];
}
-(void)setupSwipe{
    backBar=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buttonBackground"]];
    backBar.hidden=YES;
    [self.webview addSubview:backBar];
    
    UISwipeGestureRecognizer* downSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showSwipeControl)];
    downSwipeRecognizer.delegate=self;
    downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    downSwipeRecognizer.cancelsTouchesInView = YES;
    [self.webview addGestureRecognizer:downSwipeRecognizer];
    
    UISwipeGestureRecognizer* upSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideSwipeControl)];
    upSwipeRecognizer.delegate=self;
    upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    upSwipeRecognizer.cancelsTouchesInView = YES;
    [self.webview addGestureRecognizer:upSwipeRecognizer];
    
    backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"barButtonBack"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"barButtonBackDisabled"] forState:UIControlStateDisabled];
    [backButton setImage:[UIImage imageNamed:@"barButtonBackPressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backwardTap:) forControlEvents:UIControlEventTouchUpInside];
    backButton.hidden=YES;
    [self.webview addSubview:backButton];
    
    forwardButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:[UIImage imageNamed:@"barButtonForward"] forState:UIControlStateNormal];
    [forwardButton setImage:[UIImage imageNamed:@"barButtonForwardDisabled"] forState:UIControlStateDisabled];
    [forwardButton setImage:[UIImage imageNamed:@"barButtonForwardPressed"] forState:UIControlStateHighlighted];
    [forwardButton addTarget:self action:@selector(forwardTap:) forControlEvents:UIControlEventTouchUpInside];
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
        self.loadLogo.hidden=NO;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.flakeAnimation stopAnimating];
    self.flakeAnimation.hidden=YES;
    self.loadFigure.hidden=YES;
    self.loadBackground.hidden=YES;
    self.loadLogo.hidden=YES;
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(!redirect){
        if(error.code==kCFURLErrorNotConnectedToInternet||error.code==kCFURLErrorTimedOut){
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
    [self setLoadBackground:nil];
    [self setLoadFigure:nil];
    [self setFlakeAnimation:nil];
    [super viewDidUnload];
}
-(void)menuTap:(NSString *)menuItem{
    if([menuItem isEqualToString:@"Home"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
    else if([menuItem isEqualToString:@"Weather"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/weather/?app=1"]];
    else if([menuItem isEqualToString:@"Gear"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/gear/?app=1"]];    
    else if([menuItem isEqualToString:@"Brains"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/brains/?app=1"]];
    else if([menuItem isEqualToString:@"Squaw"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/squaw/?app=1"]];
    else if([menuItem isEqualToString:@"Jackson"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/jackson/?app=1"]];
    else if([menuItem isEqualToString:@"Whistler"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/whistler/?app=1"]];
    else if([menuItem isEqualToString:@"Alaska"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/alaska/?app=1"]];
    else if([menuItem isEqualToString:@"Japan"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/japan/?app=1"]];
    else if([menuItem isEqualToString:@"Alps"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/alps/?app=1"]];
    else if([menuItem isEqualToString:@"PNW"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/pacificnorthwest/?app=1"]];
    else if([menuItem isEqualToString:@"Utah"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/utah/?app=1"]];
    else if([menuItem isEqualToString:@"South America"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/southamerica/?app=1"]];
    else if([menuItem isEqualToString:@"Mammoth"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/mammoth/?app=1"]];
    else if([menuItem isEqualToString:@"Brain Videos"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/brainvideos/?app=1"]];
    else if([menuItem isEqualToString:@"Non-Brain Videos"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/nonbrain/?app=1"]];
    else if([menuItem isEqualToString:@"Trailers"])
        [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/trailers/?app=1"]];
}
//    [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/locations/?app=1"]];

//    [self loadWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/category/video/?app=1"]];



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
-(void)showSwipeControl{
    if(backButton.isHidden&&forwardButton.isHidden){
        backBar.frame=CGRectMake(0, self.webview.bounds.size.height-30, self.webview.bounds.size.width, 30);
        backBar.hidden=NO;
        backButton.frame=CGRectMake(0, self.webview.bounds.size.height-30, 20, 30);
        backButton.hidden=NO;
        if(!self.webview.canGoBack)
           [backButton setEnabled:NO];
        else
           [backButton setEnabled:YES];
        forwardButton.frame=CGRectMake(self.webview.bounds.size.width-20, self.webview.bounds.size.height-30, 20, 30);
        forwardButton.hidden=NO;
        if(!self.webview.canGoForward)
            [forwardButton setEnabled:NO];
        else
            [forwardButton setEnabled:YES];
    }
}
-(void)hideSwipeControl{
    backButton.hidden=YES;
    forwardButton.hidden=YES;
    backBar.hidden=YES;
}
-(IBAction)backwardTap:(id)sender{
    [self.webview goBack];
}
-(IBAction)forwardTap:(id)sender{
    [self.webview goForward];
}
-(void)setupSideMenu{
    __weak ViewController *weakSelf = self;
    // if you want to listen for menu open/close events
    // this is useful, for example, if you want to change a UIBarButtonItem when the menu closes
    self.navigationController.delegate=self;
    self.navigationController.sideMenu.menuStateEventBlock = ^(MFSideMenuStateEvent event) {
        switch (event) {
            case MFSideMenuStateEventMenuWillOpen:
                // the menu will open
                weakSelf.navigationItem.title = @"Menu Will Open!";
                break;
            case MFSideMenuStateEventMenuDidOpen: {
                // the menu finished opening
                weakSelf.navigationItem.title = @"Menu Opened!";
                break;
            }
            case MFSideMenuStateEventMenuWillClose:
                // the menu will close
                weakSelf.navigationItem.title = @"Menu Will Close!";
                break;
            case MFSideMenuStateEventMenuDidClose:
                // the menu finished closing
                weakSelf.navigationItem.title = @"Menu Closed!";
                break;
        }
        NSLog(@"event occurred: %@", weakSelf.navigationItem.title);
        [weakSelf setupMenuBarButtonItems];
    };
}
- (void)setupMenuBarButtonItems {
    switch (self.navigationController.sideMenu.menuState) {
        case MFSideMenuStateClosed:
            self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
            self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
            break;
        case MFSideMenuStateLeftMenuOpen:
            self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
            break;
        case MFSideMenuStateRightMenuOpen:
            self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
            break;
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self.navigationController.sideMenu
            action:@selector(toggleLeftSideMenu)];
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self.navigationController.sideMenu
            action:@selector(toggleRightSideMenu)];
}
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
    return (UIInterfaceOrientationMaskAll|UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationPortrait);
}

@end
