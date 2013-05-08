//
//  AppDelegate.h
//  ShareKitARC
//
//  Created by globaltech on 4/1/13.
//  Copyright (c) 2013 globaltech. All rights reserved.
//
//
//
//  Edited and Converted to ARC by Yasin Yalcinkaya Appril 1, 2013
//

#import <UIKit/UIKit.h>

@interface ShareKitAppDelegate : UIResponder  <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

