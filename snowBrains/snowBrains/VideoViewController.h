//
//  VideoViewController.h
//  snowBrains
//
//  Created by Patrick on 13/04/16.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface VideoViewController : UIViewController

@property (nonatomic, assign) id delegate;

@end
@protocol VideoViewControllerDelegate <NSObject>

@required
-(void)loadpage:(NSURL *)url;

@end
