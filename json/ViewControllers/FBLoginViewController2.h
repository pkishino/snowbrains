//
//  FBLoginViewController2.h
//  json
//
//  Created by Patrick Ziegler on 18/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK.h>

@interface FBLoginViewController2 : UIViewController
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *profileName;

@end
