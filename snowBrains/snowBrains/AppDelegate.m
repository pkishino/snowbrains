//
//  AppDelegate.m
//  webapp
//
//  Created by Patrick on 13/04/10.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "AppDelegate.h"
#import "RNCachingURLProtocol.h"
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "ViewController.h"
#import <Socialize/Socialize.h>

#import "SHK.h"
#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#import "MyShareKitConfig.h"

#define WIDTH_IPHONE_5 568
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == WIDTH_IPHONE_5)

@implementation AppDelegate
- (ViewController *)viewController {
    return [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self viewController]];
}

- (MFSideMenu *)sideMenu {
    LeftMenuViewController *leftSideMenuController = [[LeftMenuViewController alloc] init];
    RightMenuViewController *rightSideMenuController = [[RightMenuViewController alloc] init];
    UINavigationController *navigationController = [self navigationController];
    
    MFSideMenu *sideMenu = [MFSideMenu menuWithNavigationController:navigationController
                                             leftSideMenuController:leftSideMenuController
                                            rightSideMenuController:rightSideMenuController];
    leftSideMenuController.sideMenu = sideMenu;
    rightSideMenuController.sideMenu = sideMenu;
    
    return sideMenu;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self sideMenu].navigationController;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
    
    if (IS_IPHONE_5)
    {
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBarBackground-Landscape5"] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    else
    {
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBarBackground-Landscape"] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"barButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"buttonBackground"]];
    
    //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    // set the socialize api key and secret, register your app here: http://www.getsocialize.com/apps/
    [Socialize storeConsumerKey:@"7bd30ae2-ccda-4b61-b5bc-43986b877862"];
    [Socialize storeConsumerSecret:@"7871baed-d109-41cb-91bc-2d5422adb865"];
    
    // Register for Apple Push Notification Service
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    // Handle Socialize notification at launch
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        [self handleNotification:userInfo];
    }
    
    // Specify a Socialize entity loader block
    [Socialize setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity>entity) {
        
        SampleEntityLoader *entityLoader = [[SampleEntityLoader alloc] initWithEntity:entity];
        
        if (navigationController == nil) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entityLoader];
            [self.window.rootViewController presentModalViewController:navigationController animated:YES];
        } else {
            [navigationController pushViewController:entityLoader animated:YES];
        }
    }];
    [SHK flushOfflineQueue];
    
    DefaultSHKConfigurator *configurator=[[MyShareKitConfig alloc]init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
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
    }    
    return YES;
}

@end
