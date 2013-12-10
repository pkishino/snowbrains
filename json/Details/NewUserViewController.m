//
//  NewUserViewController.m
//  json
//
//  Created by Patrick Ziegler on 9/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "NewUserViewController.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

-(void)viewDidLoad{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 137.0, self.view.frame.size.width, 1.0)];
	lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	UIView *lineViewInner = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.5, self.view.frame.size.width, 0.5)];
	// This is the default UITableView separator color
	lineViewInner.backgroundColor = [UIColor colorWithHue:360/252 saturation:0.02 brightness:0.80 alpha:1];
	lineViewInner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[lineView addSubview:lineViewInner];
	
	[self.headerView addSubview:lineView];
}

- (void)viewWillAppear:(BOOL)animated
{
	// When the modal is launched
	// Focus text view/show keyboard immediately
	if (!animated) {
		[self.nameTextView becomeFirstResponder];
	}
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField==self.nameTextView){
        [self.emailTextView becomeFirstResponder];
    }
    if(self.nameTextView.text.length>0&&self.emailTextView.text.length>0){
        [self.saveButton setEnabled:YES];
    }
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
	// When coming back from the location chooser
	// Focus text view/show keyboard after animation has finished
	if (animated) {
		[self.nameTextView becomeFirstResponder];
	}
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(self.nameTextView.text&&self.emailTextView.text){
        [self.saveButton setEnabled:YES];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSDictionary* user=[NSDictionary dictionaryWithObjectsAndKeys:self.nameTextView.text,@"name",self.emailTextView.text,@"email", nil];
    [[NSUserDefaults standardUserDefaults] setValue:user forKey:@"defaultUser"];
    NSMutableArray*userCounts=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"users"]];
    if(!userCounts){
        userCounts=[NSMutableArray array];
    }
    [userCounts addObject:user];
    [[NSUserDefaults standardUserDefaults]setValue:userCounts forKey:@"users"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
