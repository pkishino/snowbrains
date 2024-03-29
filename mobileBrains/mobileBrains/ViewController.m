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
#import "ShareKit.h"
#import "AppDelegate.h"
#import "Burstly.h"
#import "BurstlyAdUtils.h"
#import "Reachability.h"

#define APP_ID @"CPcPR5EkQkuQeUYJLq0_Pw"
#define BANNER_ZONE_ID @"0658158179055264121"

NSString *appName;

@interface ViewController (){
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
    BOOL offlineMode;
}

@end

@implementation ViewController
//@synthesize webview;
-(id)init{
    if(self=[super init]){
//        client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.snowbrains.com/"]];
        NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
        appName=[appInfo objectForKey:@"CFBundleDisplayName"];
        
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
    self.navigationItem.titleView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalImages"] valueForKey:@"logoImage"]]];
    //add imagaes for viewcontroller.xib
    self.loadFigure.frame=CGRectMake(122, self.spinner.frame.origin.y+50, 76, 162);
    self.loadFigure.image=[UIImage imageNamed:[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalImages"] valueForKey:@"headlessImage"]];
    self.spinner.image=[UIImage imageNamed:[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalImages"] valueForKey:@"spinnerImage"]];
    self.loadLogo.image=[UIImage imageNamed:[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalImages"] valueForKey:@"logoImage"]];
    self.loadBackground.image=[UIImage imageNamed:[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalImages"] valueForKey:@"loadingImage"]];
    [self.webview setDelegate:self];
    self.webview.backgroundColor=[UIColor grayColor];
    
    self.webview.allowsInlineMediaPlayback=YES;
    [self setupPullDownRefresh];
    //    [self setupAnimation];
    [self setupSwipe];
    [self setupToolBar];
    [self setupSideMenu];
#if IAD_ENABLED
    self.bannerView.delegate=self;
    self.bannerView.hidden=YES;
#endif
#if BURSTLY_ENABLED
    [Burstly setLogLevel:AS_LOG_LEVEL_DEBUG];
    CGRect bannerFrame=CGRectMake(self.view.frame.size.width / 2 - BBANNER_SIZE_320x53.width / 2, self.view.frame.size.height - BBANNER_SIZE_320x53.height, BBANNER_SIZE_320x53.width, BBANNER_SIZE_320x53.height);
//    CGRect bannerFrame=CGRectMake(0, 200, BBANNER_SIZE_320x53.width, BBANNER_SIZE_320x53.height);

    self.burstlyBanner=[[BurstlyBannerAdView alloc] initWithAppId:APP_ID zoneId: BANNER_ZONE_ID frame:bannerFrame anchor:kBurstlyAnchorBottom rootViewController:self delegate:self];
    [self.burstlyBanner setBackgroundColor:[UIColor grayColor]];
//    [self.burstlyBanner setAlpha:0.6];
    
    [self.burstlyBanner setDefaultRefreshInterval:10];
    
    [self.view addSubview:self.burstlyBanner];
    [self.burstlyBanner showAd];
    
    [self.burstlyBanner setHidden:YES];
    [self.burstlyBanner setAdPaused:YES];
#endif
    
    [self viewWillLayoutSubviews];
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
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadAbout:)
     name:@"AboutURL"
     object:nil];
    
    self.webview.scrollView.scrollsToTop=YES;
    [self postReview];
    if(!toForward){
        [self menuTap:[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalURLS"] valueForKey:@"Home"] menuItem:@"Home"];
    }
}
-(void)postReview{
    [Appirater setDelegate:self];
    [Appirater appLaunched:YES];
    
}
-(void)loadAbout:(NSNotification *)notification{
    [self loadWithURL:[notification.userInfo valueForKey:@"AboutURL"]];
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
    int new=[[NSUserDefaults standardUserDefaults]integerForKey:@"refresh_timer"];
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",new] forKey:@"refresh_title"];
    [TestFlight passCheckpoint:@"changing settings"];
}
-(void)loadWithURL:(NSURL *)url{
    NSString *path=[NSString stringWithFormat:@"%@",url];
    if ([self linkChecker:path]){
        url=[NSURL URLWithString:[self linkCorrecter:path]];
    [self.webview stopLoading];
    
//    [self networkActivity];
    NSURLRequest *request;
    if([Reachability reachabilityForInternetConnection].currentReachabilityStatus==NotReachable){
        offlineMode=YES;
        request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    }else{
        offlineMode=NO;
        request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    }
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
    
    [self.webview loadRequest:request];
    [TestFlight passCheckpoint:@"load page"];
    }
    
    
}
-(void)networkActivity{
    if(!offlineMode){
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self hideSwipeControl];
    self.spinner.hidden=NO;
    [self setupAnimation];
    [self.spinner startAnimating];
    if(!self.loadFigure.isHidden&&!toForward){
        self.loadFigure.hidden=NO;
        self.loadBackground.hidden=NO;
        self.loadLogo.hidden=NO;
    }
    }
}
-(void)stopNetworkActivity{
//    if(!offlineMode){
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self.spinner stopAnimating];
    self.spinner.hidden=YES;
    self.loadFigure.hidden=YES;
    self.loadBackground.hidden=YES;
    self.loadLogo.hidden=YES;
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
//    }
}
-(void)noAccessPage{
    [self webViewDidFinishLoad:nil];
}
-(void)setupToolBar{
    self.toolBar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalImages"] valueForKey:@"buttonBackgroundColour"]]];
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
    PullToRefreshView *pull=[[PullToRefreshView alloc]initWithScrollView:self.webview.scrollView];
    [pull setDelegate:self];
    pull.tag=998;
    [self.webview.scrollView addSubview:pull];
}
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if([Reachability reachabilityForInternetConnection].currentReachabilityStatus==NotReachable){
        [self cancelPullToRefresh];
    }else{
    [(UIWebView *)[self.view viewWithTag:999] reload];
    [self networkActivity];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(cancelPullToRefresh) userInfo:nil repeats:NO];
    [TestFlight passCheckpoint:@"pull to refresh"];
    }
}
-(void)cancelPullToRefresh{
    if([(PullToRefreshView *)[self.view viewWithTag:998] getState]==PullToRefreshViewStateLoading){
        [self.webview stopLoading];
        [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Connection Error", @"Connection Error") message:NSLocalizedString(@"Could not refresh the current page, please check your internet connection",@"Could not refresh message") delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"OK button") otherButtonTitles:nil];
        [alert show];
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:4];
        [self noAccessPage];
        [TestFlight passCheckpoint:@"pull to refresh load fail"];
    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self networkActivity];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopNetworkActivity];
    [TestFlight passCheckpoint:@"page loaded"];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(!redirect){
        int errorCode=error.code*-1;
        if(errorCode==1009){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Offline Mode",@"Offline mode") message:NSLocalizedString(@"Could not connect to the internet, displaying last viewed version",@"Offline mode message") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:4];
            [self noAccessPage];
            [TestFlight passCheckpoint:@"offline mode"];
            return;
            
        }else if(offlineMode){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Cache", @"No Cache") message:NSLocalizedString(@"You are offline and this page has not been saved yet. Only pages you have visited before can be viewed offline",@"No Offline cache message") delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"OK button") otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:4];
        }else if(1021>=errorCode&&errorCode>=1000){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Connection Error", @"Connection Error") message:NSLocalizedString(@"Could not load the requested page, please check that you have Internet Access", @"No access") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK button") otherButtonTitles:nil];
            [alert show];
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:4];
            [self noAccessPage];
            [TestFlight passCheckpoint:@"no access"];
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
    NSLog(@"%@",requestString);
    if(navigationType==UIWebViewNavigationTypeLinkClicked||navigationType==UIWebViewNavigationTypeReload){
        if(![self linkChecker:requestString]){
            if([requestString rangeOfString:@"youtube.com"].location!=NSNotFound){
                [self loadYoutube:requestString];
                return NO;
            }else{
                //if the request is to outside of snowbrains then ask if user wants to open in safari
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"External site",@"External site") message:NSLocalizedString(@"This link leads to an external site , please press OK to load with your default browser or cancel to stay here",@"Load external message") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel button") otherButtonTitles:NSLocalizedString(@"OK",@"OK button"),nil];
                [alert show];
                NSLog(@"%@",requestString);
                [self noAccessPage];
                return NO;
            }
        }
        else{
            NSURL *redirectTo=[NSURL URLWithString:[self linkCorrecter:requestString]];
            redirect=YES;
            [self loadWithURL:redirectTo];
            return NO;
        }
    }
    if(self.webview.request==request){
        return NO;
    }
    if ([requestString rangeOfString:@"#comment-"].location!=NSNotFound){
        requestString=[requestString substringToIndex:[requestString rangeOfString:@"#comment-"].location];
        NSURL *redirectTo=[NSURL URLWithString:[self linkCorrecter:requestString]];
        redirect=YES;
        [self loadWithURL:redirectTo];
        return NO;
    }
    return YES;
}
-(NSString *)linkCorrecter:(NSString *)link{
    NSLog(@"%@",link);
    if ([link rangeOfString:@"?app=1"].location==NSNotFound&&([link rangeOfString:@"http://snowbrains.com"].location!=NSNotFound||[link rangeOfString:@"http://www.snowbrains.com"].location!=NSNotFound||[link rangeOfString:[[NSString stringWithFormat:@"http://%@.com",appName] lowercaseString]].location!=NSNotFound||[link rangeOfString:[[NSString stringWithFormat:@"http://www.%@.com",appName] lowercaseString]].location!=NSNotFound)&&([link rangeOfString:@"/wp-"].location==NSNotFound||[link rangeOfString:@".php"].location==NSNotFound)){
        NSRange range=NSMakeRange(0, link.length);
        NSRange rangeOfLastDash=[link rangeOfString:@"/" options:NSBackwardsSearch range:range];
        if(rangeOfLastDash.location+1<link.length){
            link=[NSString stringWithFormat:@"%@/?app=1",link];
        }else{
        link=[link substringToIndex:rangeOfLastDash.location+1];
        link=[link stringByReplacingCharactersInRange:rangeOfLastDash withString:@"/?app=1"];
        }
        
        return link;
    }else
        return link;
}
-(BOOL)linkChecker:(NSString *)link{
    NSLog(@"%@",link);
    if (([link rangeOfString:@"http://www.snowbrains.com"].location==NSNotFound&&[link rangeOfString:@"http://snowbrains.com"].location==NSNotFound)&&[link rangeOfString:[[NSString stringWithFormat:@"http://%@.com",appName] lowercaseString]].location==NSNotFound&&[link rangeOfString:[[NSString stringWithFormat:@"http://www.%@.com",appName] lowercaseString]].location==NSNotFound){
        return NO;
    }else
        return YES;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( buttonIndex == 1 ) [[UIApplication sharedApplication]openURL:[NSURL URLWithString:requestString]];
    [TestFlight passCheckpoint:@"launch safari"];
}
-(void)dismissAlertView:(UIAlertView *)alertView{
    if(alertView)[alertView dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)loadYoutube:(NSString *)request{
    
    UIViewController *video=[[UIViewController alloc]init];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: NSLocalizedString(@"Back",@"Back button")
                                   style: UIBarButtonItemStyleBordered
                                   target: self action: @selector(dismissModalViewControllerAnimated:)];
    
    [video.navigationItem setLeftBarButtonItem:backButton animated:YES];
    UINavigationController *bar=[[UINavigationController alloc]initWithRootViewController:video];
    //    [bar.navigationItem setLeftBarButtonItem:backButton animated:YES];
    video.title=NSLocalizedString(@"Video",@"Video");
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:self.view.frame];
    }
    video.view =videoView;
    [videoView setMediaPlaybackRequiresUserAction:NO];
    [videoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request]]];
    [self presentModalViewController:bar animated:YES];
    [TestFlight passCheckpoint:@"launching video"];
}


-(void)menuTap:(NSURL *)url menuItem:(NSString *)menuItem{
    menuSelection=menuItem;
    [self loadWithURL:url];
}
-(void)search:(NSString *)searchItem{
    [self loadWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.snowbrains.com/search/%@/?app=1",searchItem]]];
    [TestFlight passCheckpoint:@"searching"];
}

-(void)setupAnimation{
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    fullRotation.duration = 5.0;
    fullRotation.repeatCount = HUGE_VALF;
    [self.spinner.layer addAnimation:fullRotation forKey:@"flakeAnimation"];
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
    [self viewWillLayoutSubviews];
    
}
-(void)hideSwipeControl{
    self.toolBar.hidden=YES;
    [self viewWillLayoutSubviews];
}
-(IBAction)backwardTap:(id)sender{
    [self hideSwipeControl];
    [self.webview goBack];
    [TestFlight passCheckpoint:@"webview back"];
}
-(IBAction)forwardTap:(id)sender{
    [self hideSwipeControl];
    [self.webview goForward];
    [TestFlight passCheckpoint:@"webview forward"];
}

- (IBAction)bookmarkTap:(id)sender {
    NSURL *toBookmark=self.webview.request.URL;
    if([self linkChecker:[NSString stringWithFormat:@"%@",toBookmark]]){
        BookmarkModalViewController *bookmarkAdd=[[BookmarkModalViewController alloc]initWithURL:toBookmark andCategory:menuSelection];
        [self presentModalViewController:bookmarkAdd animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"Wrong bookmark url error") message:NSLocalizedString(@"Sorry, this page cannot be bookmarked", @"wrong url bookmark message") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"OK button") otherButtonTitles: nil];
        [alert show];
        NSLog(@"%@",toBookmark);
        [TestFlight passCheckpoint:@"bookmark failed to open"];
    }
}
-(void)bookmarkLoad:(NSString *)bookmark{
    [self loadWithURL:[NSURL URLWithString:bookmark]];
    [TestFlight passCheckpoint:@"loaded bookmark"];
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
    [self viewWillLayoutSubviews];
    [TestFlight passCheckpoint:@"rotated"];
    if (self.loadFigure.isHidden) {
        return YES;
    }
    return NO;
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
    NSString *textToShare = NSLocalizedString(@"Input text to share",@"Input text default");
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
    
    SHKItem *item = [SHKItem URL:[NSURL URLWithString:request] title:[NSString stringWithFormat:@"%@ is Awesome!",appName] contentType:SHKURLContentTypeWebpage];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromToolbar:self.toolBar];
    [TestFlight passCheckpoint:@"Share pressed"];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {}

//iAD delegate methods
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
#if BURSTLY_ENABLED
    [self.burstlyBanner setHidden:YES];
    [self.burstlyBanner setAdPaused:YES];
#endif
    self.bannerView.hidden=NO;
    [self resizeWebView];
}
- (BOOL)bannerViewActionShouldBegin:
(ADBannerView *)banner
               willLeaveApplication:(BOOL)willLeave
{
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
#if BURSTLY_ENABLED
    [self.burstlyBanner setHidden:NO];
    [self.burstlyBanner setAdPaused:NO];
    [self.burstlyBanner showAd];
#endif
    [self.bannerView setHidden:YES];
    [self resizeWebView];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
#if BURSTLY_ENABLED
    [self.burstlyBanner setHidden:NO];
    [self.burstlyBanner setAdPaused:NO];
    [self.burstlyBanner showAd];
#endif
    self.bannerView.hidden=YES;
    NSLog(@"%@",error);
    [self resizeWebView];
}

//burstly banner delegate methods
// Sent when the ad view takes over the screen when the banner is clicked. Use this callback as an
// oppurtunity to implement state specific details such as pausing animation, timers, etc. The
// exact timing of this callback is not guaranteed as a few ad networks roll out the canvas
// prior to sending a callback whereas some others do the opposite. The following ad networks
// notify us prior to rolling out the canvas.
// Admob, Greystripe, Inmobi
// @param: adNetwork - Specifies the adNetwork that was displayed.
-(void) burstlyBannerAdView:(BurstlyBannerAdView *)view willTakeOverFullScreen:(NSString*)adNetwork
{
    
}

// Sent when the ad view is dismissed from screen.
-(void) burstlyBannerAdView:(BurstlyBannerAdView *)view willDismissFullScreen:(NSString*)adNetwork
{
    
}
//-(void) burstlyBannerAdView:(BurstlyBannerAdView *)view didHide:(NSString*)lastViewedNetwork{
//    [self.burstlyBanner setHidden:YES];
//    [self resizeWebView];
//    
//}
//
//
//-(void) burstlyBannerAdView:(BurstlyBannerAdView *)view didShow:(NSString*)adNetwork{
//    [self resizeWebView];
//    [self.burstlyBanner setHidden:NO];
//}


//-(void) burstlyBannerAdView:(BurstlyBannerAdView *)view didCache:(NSString*)adNetwork{
//    
//}
//
//
//-(void) burstlyBannerAdView:(BurstlyBannerAdView *)view wasClicked:(NSString*)adNetwork{
//    
//}


-(void) burstlyBannerAdView:(BurstlyBannerAdView *)view didFailWithError:(NSError *)error{
    self.burstlyBanner.hidden=YES;
    [self.burstlyBanner setAdPaused:YES];
    [self resizeWebView];
    NSLog(@"Failed to load banner: %@", error.description);
    switch (error.code)
    {
        case BurstlyErrorInvalidRequest:
            
            break;
        case BurstlyErrorNoFill:
            
            break;
        case BurstlyErrorNetworkFailure:
            
            break;
        case BurstlyErrorServerError:
            
            break;
        case BurstlyErrorInterstitialTimedOut:
            
            break;
        case BurstlyErrorRequestThrottled:
            
            break;
        case BurstlyErrorConfigurationError:
            
            break;
        default:
            
            break;
    };
}
- (void)viewWillLayoutSubviews
{
    // It's smart to override this method for repositioning banners.
    [super viewWillLayoutSubviews];
    
    // Reposition banner frame.
//    CGRect bannerFrame = CGRectMake(0, 200, self.view.bounds.size.width, BBANNER_SIZE_320x53.height);
//    [self.burstlyBanner setFrame:bannerFrame];
    if (self.bannerView.bannerLoaded&&!self.bannerView.isHidden) {
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
#if BURSTLY_ENABLED
    if (self.burstlyBanner&&!self.burstlyBanner.isHidden) {
        if(self.toolBar.isHidden){
            CGRect contentFrame = self.view.bounds;
            CGRect bannerFrame = self.burstlyBanner.frame;
            contentFrame.size.height -= self.burstlyBanner.frame.size.height;
            bannerFrame.origin.y = contentFrame.size.height;
            self.burstlyBanner.frame = bannerFrame;
        }else{
            CGRect contentFrame = self.view.bounds;
            CGRect bannerFrame = self.burstlyBanner.frame;
            contentFrame.size.height -= self.burstlyBanner.frame.size.height;
            bannerFrame.origin.y = self.toolBar.frame.origin.y-self.burstlyBanner.frame.size.height;
            self.burstlyBanner.frame = bannerFrame;
        }
    }
#endif
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft||orientation==UIInterfaceOrientationLandscapeRight){
        if(!self.loadFigure.isHidden)
            self.loadFigure.frame=CGRectMake(202, self.spinner.frame.origin.y+50, 76, 102);
        self.bannerView.requiredContentSizeIdentifiers=[NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
        self.bannerView.currentContentSizeIdentifier=ADBannerContentSizeIdentifierLandscape;
    }else{
        if(!self.loadFigure.isHidden)
            self.loadFigure.frame=CGRectMake(122, self.spinner.frame.origin.y+50, 76, 162);
        self.bannerView.requiredContentSizeIdentifiers=[NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        self.bannerView.currentContentSizeIdentifier=ADBannerContentSizeIdentifierPortrait;
    }
    
    [self resizeWebView];
}
-(void)resizeWebView{
    CGRect frame=self.view.frame;
    frame.origin=CGPointMake(0, 0);
    if(self.bannerView.bannerLoaded&&!self.bannerView.isHidden){
        frame.size.height-=self.bannerView.frame.size.height;
    }
#if BURSTLY_ENABLED
    if(self.burstlyBanner&&!self.burstlyBanner.isHidden){
        frame.size.height-=self.burstlyBanner.frame.size.height;
    }
#endif
    if(!self.toolBar.isHidden)
        frame.size.height-=self.toolBar.frame.size.height;
    self.webview.frame =frame;
    [self.webview setNeedsDisplay];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [self dismissModalViewControllerAnimated:YES];
    [TestFlight passCheckpoint:@"Dismissed mail"];
}
//-(IBAction)launchFeedback { [TestFlight openFeedbackView]; }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebview:nil];
    [self setLoadBackground:nil];
    [self setLoadFigure:nil];
    [self setSpinner:nil];
    [self setToolBar:nil];
    [self setShareButton:nil];
    [self setBackButton:nil];
    [self setShareButton:nil];
    [self setForwardButton:nil];
    [self setBookmarkButton:nil];
    [super viewDidUnload];
}
@end
