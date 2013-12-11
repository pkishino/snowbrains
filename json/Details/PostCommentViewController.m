//
//  PostCommentViewController.m
//  json
//
//  Created by Patrick Ziegler on 9/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostCommentViewController.h"
#import "CommentPoster.h"
#import "ErrorAlert.h"

@interface PostCommentViewController (){
    NSDictionary* defaultUser;
}

@end

@implementation PostCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDefaultUser];
}
- (void)viewWillAppear:(BOOL)animated
{
	// When the modal is launched
	// Focus text view/show keyboard immediately
	if (!animated) {
		[self.commentTextView becomeFirstResponder];
	}
        [self setDefaultUser];
}

- (void)viewDidAppear:(BOOL)animated
{
	// When coming back from the location chooser
	// Focus text view/show keyboard after animation has finished
	if (animated) {
		[self.commentTextView becomeFirstResponder];
	}
        [self setDefaultUser];
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length>0&&defaultUser){
        [self.postButton setEnabled:YES];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - IBActions

- (IBAction)cancelButtonTapped:(id)sender{
	[self.commentTextView resignFirstResponder];
	[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)postButtonTapped:(id)sender{
    NSDictionary *postComment=[NSDictionary dictionaryWithObjectsAndKeys:self.post_id,@"post_id",self.commentTextView.text,@"content",[defaultUser valueForKey:@"name"],@"name",[defaultUser valueForKey:@"email"],@"email", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommentPoster postComment:postComment andCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [self.commentTextView resignFirstResponder];
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }else{
            [ErrorAlert postError:error];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - UITableViewDelegate delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Other methods

- (IBAction)hideKeyboard:(id)sender{
	[self.commentTextView resignFirstResponder];
}
-(void)setDefaultUser{
    defaultUser=[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultUser"];
    if(defaultUser){
        [self setUserTitle:[defaultUser valueForKey:@"name"]];
    }
}
- (void)setUserTitle:(NSString *)userTitle{
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	cell.detailTextLabel.text = userTitle;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}
-(IBAction)selectedUserReturn:(UIStoryboardSegue*)segue{
    defaultUser=[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultUser"];
    if(self.commentTextView.text.length>0&&defaultUser){
        [self.postButton setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
