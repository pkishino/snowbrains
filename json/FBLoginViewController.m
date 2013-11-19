//
//  FBLoginViewController.m
//  json
//
//  Created by Patrick Ziegler on 17/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "FBLoginViewController.h"
#import "AppDelegate.h"

@interface FBLoginViewController ()

@end

@implementation FBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self showUserDetails];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        // To-do, show logged in view
//    } else {
//        // No, display the login page.
//        [self showLoginView];
//    }
}
-(void)showLoginView{
    
}
- (void)setShouldSkipLogIn:(BOOL)skip {
    [[NSUserDefaults standardUserDefaults] setBool:skip forKey:@"TestJson"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldSkipLogIn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"TestJson"];
}
-(void)showUserDetails{
//    if (FBSession.activeSession.isOpen) {
//        [[FBRequest requestForMe] startWithCompletionHandler:
//         ^(FBRequestConnection *connection,
//           NSDictionary<FBGraphUser> *user,
//           NSError *error) {
//             if (!error) {
//                 self.profileName.text = user.name;
//                 self.profilePicture.profileID = user.id;
//             }
//         }];
//    }
}
#pragma mark - FBLoginView delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // if you become logged in, no longer flag to skip log in
    self.shouldSkipLogIn = NO;
//    [self showUserDetails];
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user{
    self.profileName.text = user.name;
    self.profilePicture.profileID = user.id;
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}



- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePicture.profileID=0;
    self.profileName.text=nil;
}
- (void)logOut {
    // on log out we reset the main view controller
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
