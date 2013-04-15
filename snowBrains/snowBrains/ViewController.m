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
    //[self.webview addSubview:currentScrollView]
    //[self.view addSubview:self.webview];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://www.snowbrains.com"];
    NSURLRequest *snowbrains=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    [self.webview loadRequest:snowbrains];
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
- (IBAction)locationTap:(id)sender {
    LocationViewController* popoverView=[[LocationViewController alloc]init];
    
    UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController: popoverView];
    popover.delegate=self;
    popover.popoverLayoutMargins = UIEdgeInsetsMake(self.locationButton.frame.origin.x, self.locationButton.frame.origin.x, 0, 0);
    self.pop=popover;
    if([self.pop isPopoverVisible])
       [self.pop dismissPopoverAnimated:YES];
    [self.pop presentPopoverFromRect:self.locationButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}
@end
