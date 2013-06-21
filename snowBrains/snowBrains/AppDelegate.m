//
//  AppDelegate.m
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "AppDelegate.h"
#import "RNCachingURLProtocol.h"
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "ViewController.h"

#import "SHK.h"
#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#import "SHKGooglePlus.h"
#import "MyShareKitConfig.h"
#import "InAppSettings.h"
#import "Appirater.h"

#define WIDTH_IPHONE_5 568
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == WIDTH_IPHONE_5)

@implementation AppDelegate
- (ViewController *)viewController {
//    return [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    return [[ViewController alloc]init];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self viewController]];
}

- (MFSideMenu *)sideMenu {
    UINavigationController *navigationController = [self navigationController];
    LeftMenuViewController *leftSideMenuController = [[LeftMenuViewController alloc] init];
    //to add the right menu again uncomment
//    RightMenuViewController *rightSideMenuController = [[RightMenuViewController alloc] init];
//    MFSideMenu *sideMenu = [MFSideMenu menuWithNavigationController:navigationController
//                                             leftSideMenuController:leftSideMenuController
//                                            rightSideMenuController:rightSideMenuController];
//    rightSideMenuController.sideMenu = sideMenu;
    MFSideMenu *sideMenu = [MFSideMenu menuWithNavigationController:navigationController
                                             leftSideMenuController:leftSideMenuController];
    leftSideMenuController.sideMenu = sideMenu;

    
    return sideMenu;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [TestFlight takeOff:@"c0b7b825-f506-4f0b-b73f-0d75286c3318"];
//    [TestFlight setOptions:{TFOptionLogToConsole:@NO}];
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [InAppSettings registerDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self sideMenu].navigationController;
    [self.window makeKeyAndVisible];
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *versionStr = [NSString stringWithFormat:@"%@ (%@)",
                            [appInfo objectForKey:@"CFBundleShortVersionString"],
                            [appInfo objectForKey:@"CFBundleVersion"]];
    NSString *appName=[appInfo objectForKey:@"CFBundleDisplayName"];
    [[NSUserDefaults standardUserDefaults]setValue:versionStr forKey:@"versionIdentifier"];
    [[NSUserDefaults standardUserDefaults]setValue:appName forKey:@"aboutUrl"];
    
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"header-portrait"] forBarMetrics:UIBarMetricsDefault];
    
    if (IS_IPHONE_5)
    {
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"header-iPhone5"] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    else
    {
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"header-landscape"] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"barButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"buttonBackground"]];
    
//    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                               [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttonBackground"]],UITextAttributeTextColor,
//                                               [UIColor lightGrayColor], UITextAttributeTextShadowColor,
//                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 2)], UITextAttributeTextShadowOffset, nil];
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    [SHK flushOfflineQueue];
    
    DefaultSHKConfigurator *configurator=[[MyShareKitConfig alloc]init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled=YES;
    [Appirater setAppId:@"642740107"];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setTimeBeforeReminding:2];
//    [Appirater setDebug:YES];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [SHKFacebook handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [SHKFacebook handleWillTerminate];
}
-(void)handleNotification:(NSDictionary *)userInfo{
    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url];
    } else if ([scheme isEqualToString:@"com.snowbrains.mobilebrains"]) {
        return [SHKGooglePlus handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;
}

@end
