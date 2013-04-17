//
//  MoreViewController.h
//  snowBrains
//
//  Created by Patrick on 13/04/15.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MoreViewController : UIViewController

@property (nonatomic, assign) id delegate;

@end
@protocol MoreViewControllerDelegate <NSObject>

@required
-(void)loadpage:(NSURL *)url;

@end
