//
//  SettingsViewController.m
//  mobileBrains
//
//  Created by Patrick on 13/05/02.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import "BookmarkViewController.h"

@interface BookmarkViewController ()

@end
NSString *const BookmarkViewControllerDelegateWillDismissedNotification = @"BookmarkViewControllerDelegateWillDismissedNotification";
NSString *const BookmarkViewControllerDelegateDidDismissedNotification = @"BookmarkViewControllerDelegateDidDismissedNotification";
@implementation BookmarkModalViewController

- (id)initWithURL:(NSURL *)url{
    BookmarkViewController *bookmarkView = [[BookmarkViewController alloc] init];
    self = (BookmarkModalViewController *)[[UINavigationController alloc] initWithRootViewController:bookmarkView];
    [bookmarkView addDoneButton];
    [bookmarkView addAddButton];
    bookmarkView.bookmarkURL=url;
    return self;
}

@end

@implementation BookmarkViewController

#pragma mark modal view

- (IBAction)dismissModalView:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:BookmarkViewControllerDelegateWillDismissedNotification object:self];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BookmarkViewControllerDelegateDidDismissedNotification object:self];
    }];
}
-(IBAction)addBookmark:(id)sender{
    NSMutableArray *bookmarks = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"Bookmarks"] mutableCopy];
    if (!bookmarks) {
        bookmarks = [[NSMutableArray alloc] init];
    }
    NSString *name=self.bookmarkName.text;
    name=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([name length]!=0){
    [bookmarks addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.bookmarkName.text,@"Name",[self.bookmarkURL absoluteString],@"URL", nil]];
    [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:@"Bookmarks"];
    [self dismissModalView:nil];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"error") message:NSLocalizedString(@"Please input a name for the bookmark", @"Empty bookmark name") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)addDoneButton{
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
     target:self
     action:@selector(dismissModalView:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}
- (void)addAddButton{
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
     target:self
     action:@selector(addBookmark:)];
    self.navigationItem.leftBarButtonItem = addButton;
}

#pragma mark setup view

- (id)init{
    self=[super init];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //if the title is nil set it to Settings
    if(!self.title){
        self.title = NSLocalizedString(@"Add Bookmark", nil);
    }
    
    //setup keyboard notification
    self.firstResponder = nil;
    [self registerForKeyboardNotifications];
    
    NSString *name=[NSString stringWithFormat:@"%@",self.bookmarkURL];
    NSRange match;
    NSRange match1;
    match = [name rangeOfString: @".com"];
    name=[name substringFromIndex:match.location+4];
    match1 = [name rangeOfString: @"?app=1"];
    name=[name substringToIndex:match1.location];
    name=[name stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    name=[name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    self.bookmarkName.text=name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.firstResponder = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.firstResponder = nil;
}

- (void)dealloc{
    self.firstResponder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark keyboard notification


- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    if(self.firstResponder == nil){
        CGRect keyboardEndFrame;
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        NSDictionary *userInfo = [notification userInfo];
        [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    if(self.firstResponder == nil){
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        NSDictionary *userInfo = [notification userInfo];
        [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView commitAnimations];
    }
}

- (void)viewDidUnload {
    [self setBookmarkName:nil];
    [super viewDidUnload];
}
@end
