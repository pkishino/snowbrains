//
//  FBLoginViewController.h
//  json
//
//  Created by Patrick Ziegler on 17/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK.h>

@interface FBLoginViewController : UIViewController<FBLoginViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet FBLoginView *FBLoginView;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *profileName;


@end
