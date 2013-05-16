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
}

@end

@implementation ViewController
-(id)init{
    if(self=[super init]){
//        NSURLRequest *preload=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
//        [self.webview loadRequest:preload];
//        self.webview.delegate=self;
        client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.snowbrains.com/?app=1"]];
// 
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
      
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
//                                   initWithTitle: @"Back"
//                                   style: UIBarButtonItemStyleBordered
//                                   target: nil action: nil];
//    
//    [self.navigationItem setBackBarButtonItem: backButton];
    self.bannerView.delegate=self;
    self.bannerView.hidden=YES;
    [self viewDidLayoutSubviews];
}
//-(void)loadPreloadedWeb:(NSNotification *)notification{
//    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    self.webview=mainDelegate.preLoader;
//}
-(void)loadWithURL:(NSURL *)url{
    [self.webview stopLoading];
//    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
//    [self.webview loadRequest:snowbrains];
    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:snowbrains queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
//        NSString *http=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [self.webview loadHTMLString: http baseURL:url];
//    }];
//    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc]initWithRequest:snowbrains];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //NSString *data=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        [self.webview loadData:responseObject MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:url];
//        NSLog(@"Success");
//    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure");
//    }];
     AFHTTPRequestOperation *operation=[client HTTPRequestOperationWithRequest:snowbrains success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *data=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [self.webview loadHTMLString: data baseURL:url];
        NSLog(@"Success");
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
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
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(cancelPullToRefresh) userInfo:nil repeats:NO];
}
-(void)cancelPullToRefresh{
    if([(UIWebView *)[self.view viewWithTag:999] isLoading]){
    [(UIWebView *)[self.view viewWithTag:999] stopLoading];
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Could not load the requested page, please check that you have Internet Access" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    }
}
//-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//    [self hideSwipeControl];
//    self.flakeAnimation.hidden=NO;
//    [self.flakeAnimation startAnimating];
//    if(!self.loadFigure.isHidden&&!toForward){
//        self.loadFigure.hidden=NO;
//        self.loadBackground.hidden=NO;
//        self.loadLogo.hidden=NO;
//    }
//}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self.flakeAnimation stopAnimating];
    self.flakeAnimation.hidden=YES;
    self.loadFigure.hidden=YES;
    self.loadBackground.hidden=YES;
    self.loadLogo.hidden=YES;
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
    //NSLog(@"%@",[self.webview stringByEvaluatingJavaScriptFromString: @"document.documentElement.outerHTML"]);
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(!redirect){
        int errorCode=error.code*-1;
        //if(error.code==kCFURLErrorNotConnectedToInternet||error.code==kCFURLErrorTimedOut){
        if(1021>=errorCode&&errorCode>=1000){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Could not load the requested page, please check that you have Internet Access" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.flakeAnimation stopAnimating];
            self.flakeAnimation.hidden=YES;
            self.loadFigure.hidden=YES;
            self.loadBackground.hidden=YES;
            [self.webview stopLoading];
            [(PullToRefreshView *)[self.view viewWithTag:998]finishedLoading];
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
                return YES;
//                if([requestString rangeOfString:@"iframe class"].location==NSNotFound){
//                    [self loadYoutube:requestString];
//                    return NO;
//                }
//                else
//                    return YES;
            }else{
            //if the request is to outside of snowbrains then ask if user wants to open in safari
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"External site" message:@"The requested site is outside of Snowbrains, please press OK to load with default Browser" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
            [alert show];
            return NO;
            }
        }else if ([requestString rangeOfString:@"?app=1"].location==NSNotFound){
            NSURL *redirectTo=[NSURL URLWithString:[NSString stringWithFormat:@"%@?app=1",requestString]];
            [self loadWithURL:redirectTo];
            redirect=YES;
            return NO;
        }
    }
    if(self.webview.request==request){
        return NO;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if( buttonIndex == 1 ) [[UIApplication sharedApplication]openURL:[NSURL URLWithString:requestString]];
}
//-(void)loadYoutube:(NSString *)request{
////    if([UIDevice ])
//    requestString=[requestString stringByReplacingOccurrencesOfString:@"watch?v=" withString:@"embed/"];
//    
//    NSString *youTubeHTMLTemplate = @"<html><body style=\"margin:0;padding:0;\"><iframe class=\"youtube-player\" type=\"text/html\" width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></body></html>";
//    NSString* html = [NSString stringWithFormat:youTubeHTMLTemplate, self.webview.frame.size.width, self.webview.frame.size.height, requestString];
//    if(videoView == nil) {
//        videoView = [[UIWebView alloc] initWithFrame:self.view.frame];
//        [self.view addSubview:videoView];
//    }
//    self.view.autoresizesSubviews=YES;
//    [videoView setMediaPlaybackRequiresUserAction:NO];
//    [videoView loadHTMLString:html baseURL:nil];
//    [videoView stringByEvaluatingJavaScriptFromString:@"function onPlayerReady(event){event.target.playVideo();}"];
////    [self.webview loadHTMLString:html baseURL:nil];
//    
//    
//}

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
    [self.webview goBack];
}

- (IBAction)bookmarkTap:(id)sender {
    BookmarkModalViewController *bookmarkAdd=[[BookmarkModalViewController alloc]initWithURL:self.webview.request.URL];
    [self presentModalViewController:bookmarkAdd animated:YES];
}
-(void)bookmarkLoad:(NSString *)bookmark{
    [self loadWithURL:[NSURL URLWithString:bookmark]];
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
        NSLog(@"event occurred: %@", weakSelf.navigationItem.title);
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
    self.bannerView.hidden=NO;
    NSLog(@"%c",banner.bannerLoaded);
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
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    self.bannerView.hidden=YES;
    NSLog(@"%@",error);
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
}

@end
