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
- (IBAction)brainTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *brainButton;

- (IBAction)nonBrainTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *nonBrainButton;

- (IBAction)trailerTap:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *trailerButton;

@end
@protocol VideoViewControllerDelegate <NSObject>

@required
-(void)loadpage:(NSURL *)url;

@end
