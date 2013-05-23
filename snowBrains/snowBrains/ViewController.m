//
//  ViewController.m
//  webapp
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "ViewController.h"
#import "MFSideMenu.h"
#import "SHK.h"
#import "AppDelegate.h"
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
    UIImageView * backBar;
    NSString *menuSelection;
    BOOL toForward;
    AFHTTPClient *client;
    UIWebView *videoView;
    int refreshValue;
    NSTimer *refreshTimer;
    BOOL autoRefresh;
}

@end

@implementation ViewController
-(id)init{
    if(self=[super init]){
        client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.snowbrains.com/"]];
    }
    return self;
}
-(id)initWithForward:(BOOL)forward{
    if(self=[super init]){
        toForward=forward;
    }
    return self;
}

#pragma mark -
#pragma mark - View setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webview setDelegate:self];
    if(!toForward){
        [self menuTap:@"Home"];
    }
    self.webview.allowsInlineMediaPlayback=YES;
    [self setupPullDownRefresh];
    //    [self setupAnimation];
    [self setupSwipe];
    [self setupSideMenu];
    
    self.bannerView.delegate=self;
    self.bannerView.hidden=YES;
    [self viewDidLayoutSubviews];
    refreshValue=[[NSUserDefaults standardUserDefaults]integerForKey:@"refresh_timer"];
    autoRefresh=[[NSUserDefaults standardUserDefaults]boolForKey:@"refresh_pref"];
    if(autoRefresh)refreshTimer=[NSTimer scheduledTimerWithTimeInterval:refreshValue*60 target:self selector:@selector(pullToRefreshViewShouldRefresh:) userInfo:nil repeats:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self
               forKeyPath:@"refresh_pref"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    [defaults addObserver:self
               forKeyPath:@"refresh_timer"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    [defaults addObserver:self
               forKeyPath:@"rotate_pref"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    NSLog(@"KVO: %@ changed property %@ to value %@", object, keyPath, change);
    if(refreshValue!=[[NSUserDefaults standardUserDefaults]integerForKey:@"refresh_timer"]||autoRefresh!=[[NSUserDefaults standardUserDefaults]boolForKey:@"refresh_pref"]){
        refreshValue=[[NSUserDefaults standardUserDefaults]integerForKey:@"refresh_timer"];
        autoRefresh=[[NSUserDefaults standardUserDefaults]boolForKey:@"refresh_pref"];
        if(autoRefresh){
            [refreshTimer invalidate];
            refreshTimer=[NSTimer scheduledTimerWithTimeInterval:refreshValue*60 target:self selector:@selector(pullToRefreshViewShouldRefresh:) userInfo:nil repeats:YES];
        }else if(refreshTimer){
            [refreshTimer invalidate];
            refreshTimer=nil;
        }
    }
}
-(void)loadWithURL:(NSURL *)url{
    [self.webview stopLoading];
    
    [self networkActivity];
    
    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
//    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation *operation=[client HTTPRequestOperationWithRequest:snowbrains success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.webview loadData:responseObject MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:url];
//    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Could not load the requested page, please check that you have Internet Access" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [self noAccessPage];
//    }];
//    [[client operationQueue] cancelAllOperations];
//    [[client operationQueue] addOperation:operation];
    
    [self.webview loadRequest:snowbrains];
    
}
-(void)networkActivity{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self hideSwipeControl];
    self.flakeAnimation.hidden=NO;
    [self setupAnimation];
    [self.flakeAnimation startAnimating];
    if(!self.loadFigure.isHidden&&!toForward){
        self.loadFigure.hidden=NO;
        self.loadBackground.hidden=NO;
        self.loadLogo.hidden=NO;
    }
}
-(void)stopNetworkActivity{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self.flakeAnimation stopAnimating];
    self.flakeAnimation.hidden=YES;
    self.loadFigure.hidden=YES;
    self.loadBackground.hidden=YES;
    self.loadLogo.hidden=YES;
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}
-(void)noAccessPage{
    [self webViewDidFinishLoad:nil];
}
-(void)setupSwipe{
    
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
    [self networkActivity];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(cancelPullToRefresh) userInfo:nil repeats:NO];
}
-(void)cancelPullToRefresh{
    if([self.webview isLoading]){
        [self.webview stopLoading];
        [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Could not load the requested page, please check that you have Internet Access" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self noAccessPage];
    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//    [self hideSwipeControl];
//    self.flakeAnimation.hidden=NO;
//    [self.flakeAnimation startAnimating];
//    if(!self.loadFigure.isHidden&&!toForward){
//        self.loadFigure.hidden=NO;
//        self.loadBackground.hidden=NO;
//        self.loadLogo.hidden=NO;
//    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self.flakeAnimation stopAnimating];
    self.flakeAnimation.hidden=YES;
    self.loadFigure.hidden=YES;
    self.loadBackground.hidden=YES;
    self.loadLogo.hidden=YES;
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(!redirect){
        int errorCode=error.code*-1;
        //if(error.code==kCFURLErrorNotConnectedToInternet||error.code==kCFURLErrorTimedOut){
        if(1021>=errorCode&&errorCode>=1000){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Could not load the requested page, please check that you have Internet Access" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self noAccessPage];
            return;
        }else if(!(error.code==kCFURLErrorCancelled)){
            [self.webview goBack];
            return;
        }
        NSLog(@"Starting timeout timer");
        [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(webViewDidFinishLoad:) userInfo:webView repeats:NO];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    for(NSString *headers in request.allHTTPHeaderFields){
//        NSLog(@"%@: %@",headers,[request valueForHTTPHeaderField:headers]);
//    }
    redirect=NO;
    requestString=[NSString stringWithFormat:@"%@",request.URL];
    if(navigationType==UIWebViewNavigationTypeLinkClicked||navigationType==UIWebViewNavigationTypeReload){
        if([requestString rangeOfString:@"http://www.snowbrains.com"].location==NSNotFound&&[requestString rangeOfString:@"http://snowbrains.com"].location==NSNotFound){
            if([requestString rangeOfString:@"youtube.com"].location!=NSNotFound){
                [self loadYoutube:requestString];
                return NO;
            }else{
                //if the request is to outside of snowbrains then ask if user wants to open in safari
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"External site" message:@"The requested site is outside of Snowbrains, please press OK to load with default Browser" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                [alert show];
                NSLog(@"%@",requestString);
                [self noAccessPage];
                return NO;
            }
        }else if ([requestString rangeOfString:@"?app=1"].location==NSNotFound){
            NSURL *redirectTo=[NSURL URLWithString:[NSString stringWithFormat:@"%@?app=1",requestString]];
            [self loadWithURL:redirectTo];
            redirect=YES;
            return NO;
        }
    }
    if ([requestString rangeOfString:@"?app=1"].location==NSNotFound&&([requestString rangeOfString:@"http://snowbrains.com"].location!=NSNotFound||[requestString rangeOfString:@"http://www.snowbrains.com"].location!=NSNotFound)&&([requestString rangeOfString:@"/wp-"].location==NSNotFound||[requestString rangeOfString:@".php"].location==NSNotFound)){
        NSRange range=NSMakeRange(0, requestString.length);
        NSRange rangeOfLastDash=[requestString rangeOfString:@"/" options:NSBackwardsSearch range:range];
        requestString=[requestString substringToIndex:rangeOfLastDash.location+1];
        requestString=[requestString stringByReplacingCharactersInRange:rangeOfLastDash withString:@"/?app=1"];
        NSLog(@"%@",requestString);
        NSURL *redirectTo=[NSURL URLWithString:requestString];
        [self loadWithURL:redirectTo];
        redirect=YES;
        return NO;
    }
    if(self.webview.request==request){
        return NO;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( buttonIndex == 1 ) [[UIApplication sharedApplication]openURL:[NSURL URLWithString:requestString]];
}
-(void)loadYoutube:(NSString *)request{
    
    UIViewController *video=[[UIViewController alloc]init];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: self action: @selector(dismissModalViewControllerAnimated:)];
    
    [video.navigationItem setLeftBarButtonItem:backButton animated:YES];
    UINavigationController *bar=[[UINavigationController alloc]initWithRootViewController:video];
    //    [bar.navigationItem setLeftBarButtonItem:backButton animated:YES];
    video.title=@"Video";
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:self.view.frame];
    }
    video.view =videoView;
    [videoView setMediaPlaybackRequiresUserAction:NO];
    [videoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request]]];
    [self presentModalViewController:bar animated:YES];
}


-(void)menuTap:(NSString *)menuItem{
    menuSelection=menuItem;
    self.navigationItem.title=menuItem;
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

-(void)search:(NSString *)searchItem{
    [self loadWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.snowbrains.com/?s=%@",searchItem]]];
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
-(void)showSwipeControl{
    if(self.loadFigure.isHidden){
        self.toolBar.hidden=NO;
        if(!self.webview.canGoBack)
            [self.backButton setEnabled:NO];
        else
            [self.backButton setEnabled:YES];
        if(!self.webview.canGoForward)
            [self.forwardButton setEnabled:NO];
        else
            [self.forwardButton setEnabled:YES];
    }
    [self viewDidLayoutSubviews];
    
}
-(void)hideSwipeControl{
    self.toolBar.hidden=YES;
    [self viewDidLayoutSubviews];
}
-(IBAction)backwardTap:(id)sender{
    [self hideSwipeControl];
    [self.webview goBack];
}
-(IBAction)forwardTap:(id)sender{
    [self hideSwipeControl];
    [self.webview goForward];
}

- (IBAction)bookmarkTap:(id)sender {
    NSURL *toBookmark=self.webview.request.URL;
    if([[NSString stringWithFormat:@"%@",toBookmark] rangeOfString:@"http://www.snowbrains.com"].location!=NSNotFound){
        BookmarkModalViewController *bookmarkAdd=[[BookmarkModalViewController alloc]initWithURL:toBookmark];
        [self presentModalViewController:bookmarkAdd animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"Wrong bookmark url error") message:NSLocalizedString(@"Sorry, this page cannot be bookmarked", @"wrong url bookmark message") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)bookmarkLoad:(NSString *)bookmark{
    [self loadWithURL:[NSURL URLWithString:bookmark]];
}

-(void)setupSideMenu{
    __weak ViewController *weakSelf = self;
    // if you want to listen for menu open/close events
    // this is useful, for example, if you want to change a UIBarButtonItem when the menu closes
    self.navigationController.delegate=self;
    self.navigationController.sideMenu.menuStateEventBlock = ^(MFSideMenuStateEvent event){
        [weakSelf setupMenuBarButtonItems];
    };
}
- (void)setupMenuBarButtonItems {
    switch (self.navigationController.sideMenu.menuState) {
        case MFSideMenuStateClosed:
            self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
            //            self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
            break;
        case MFSideMenuStateLeftMenuOpen:
            self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
            break;
        case MFSideMenuStateRightMenuOpen:
            //            self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
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
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft||orientation==UIInterfaceOrientationLandscapeRight){
        
        self.loadFigure.frame=CGRectMake(202, 159, self.loadFigure.frame.size.width, self.loadFigure.frame.size.height);
        self.bannerView.requiredContentSizeIdentifiers=[NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
        self.bannerView.currentContentSizeIdentifier=ADBannerContentSizeIdentifierLandscape;
    }else{
        self.loadFigure.frame=CGRectMake(122, 237, self.loadFigure.frame.size.width, self.loadFigure.frame.size.height);
        self.bannerView.requiredContentSizeIdentifiers=[NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        self.bannerView.currentContentSizeIdentifier=ADBannerContentSizeIdentifierPortrait;
    }
    [self viewDidLayoutSubviews];
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return[self shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll);
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self shouldAutorotate];
}

- (IBAction)shareTap:(id)sender {
    //    if( [UIActivityViewController class] ) {
    //        [self showShareSheet:sender];
    //    }else
    [self showActionSheet:sender];
}
-(void)showShareSheet:(id)sender{
    NSString *textToShare = @"Input text to share";
    NSArray *itemsToShare = [[NSArray alloc] initWithObjects:textToShare, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = [[NSArray alloc] initWithObjects: UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypePostToWeibo, nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}
-(void)showActionSheet:(id)sender{
    
    NSString *request=[NSString stringWithFormat:@"%@",self.webview.request.URL];
    if ([request rangeOfString:@"?app=1"].location!=NSNotFound){
        request=[request stringByReplacingOccurrencesOfString:@"?app=1" withString:@""];
    }
    
    SHKItem *item = [SHKItem URL:[NSURL URLWithString:request] title:@"SnowBrains is Awesome!" contentType:SHKURLContentTypeWebpage];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromToolbar:self.toolBar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self resizeWebView];
    self.bannerView.hidden=NO;
}
- (BOOL)bannerViewActionShouldBegin:
(ADBannerView *)banner
               willLeaveApplication:(BOOL)willLeave
{
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [self.bannerView setHidden:YES];
    [self resizeWebView];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    self.bannerView.hidden=YES;
    NSLog(@"%@",error);
    [self resizeWebView];
}
- (void) viewDidLayoutSubviews {
    if (self.bannerView.bannerLoaded) {
        if(self.toolBar.isHidden){
            CGRect contentFrame = self.view.bounds;
            CGRect bannerFrame = self.bannerView.frame;
            contentFrame.size.height -= self.bannerView.frame.size.height;
            bannerFrame.origin.y = contentFrame.size.height;
            self.bannerView.frame = bannerFrame;
        }else{
            CGRect contentFrame = self.view.bounds;
            CGRect bannerFrame = self.bannerView.frame;
            contentFrame.size.height -= self.bannerView.frame.size.height;
            bannerFrame.origin.y = self.toolBar.frame.origin.y-self.bannerView.frame.size.height;
            self.bannerView.frame = bannerFrame;
        }
    }
    [self resizeWebView];
}
-(void)resizeWebView{
    CGRect frame=self.view.frame;
    frame.origin=CGPointMake(0, 0);
    if(self.bannerView.bannerLoaded){
        frame.size.height-=self.bannerView.frame.size.height;
    }
    if(!self.toolBar.isHidden)
        frame.size.height-=self.toolBar.frame.size.height;
//    else
//        frame.size.height=self.view.frame.size.height;
    self.webview.frame =frame;
    [self.webview setNeedsDisplay];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [self dismissModalViewControllerAnimated:YES];
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
    [self setToolBar:nil];
    [self setShareButton:nil];
    [self setBackButton:nil];
    [self setShareButton:nil];
    [self setForwardButton:nil];
    [self setBookmarkButton:nil];
    [super viewDidUnload];
}
@end
