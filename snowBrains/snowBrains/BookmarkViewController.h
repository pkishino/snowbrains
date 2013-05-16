//
//  SettingsViewController.h
//  mobileBrains
//
//  Created by Patrick on 13/05/02.
//  Copyright (c) 2013年 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const BookmarkViewControllerDelegateWillDismissedNotification;
extern NSString *const BookmarkViewControllerDelegateDidDismissedNotification;

@interface BookmarkModalViewController : UIViewController
-(id)initWithURL:(NSURL *)url;

@end
@interface BookmarkViewController : UIViewController

@property (nonatomic,assign)id delegate;
@property (nonatomic,assign)NSURL *bookmarkURL;
@property (strong, nonatomic) IBOutlet UITextField *bookmarkName;
@property (nonatomic, weak) UIControl *firstResponder;
- (IBAction)dismissModalView:(id)sender;
- (IBAction)addBookmark:(id)sender;
- (void)addDoneButton;
- (void)addAddButton;

@end
@protocol BookmarkViewControllerDelegate <NSObject>

-(void)addBookmark:(NSString*)name withLink:(NSURL *)link;

@end