//
//  FBLoginViewController2.m
//  json
//
//  Created by Patrick Ziegler on 18/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "FBLoginViewController2.h"

@interface FBLoginViewController2 ()

@end

@implementation FBLoginViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadSession];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
-(void)loadSession{
    NSArray *permissions =
    @[@"email", @"user_photos", @"friends_photos"];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      [[FBRequest requestForMe] startWithCompletionHandler:
                                       ^(FBRequestConnection *connection,
                                         NSDictionary<FBGraphUser> *user,
                                         NSError *error) {
                                           if (!error) {
                                               self.profileName.text = user.name;
                                               self.profilePicture.profileID = user.id;
                                           }
                                       }];

                                  }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
