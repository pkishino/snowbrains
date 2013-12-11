//
//  NewUserViewController.m
//  json
//
//  Created by Patrick Ziegler on 9/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "NewUserViewController.h"

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface NewUserViewController ()

@end

@implementation NewUserViewController

-(void)viewDidLoad{
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    self.nameTextView=[[JVFloatLabeledTextField alloc] initWithFrame:
                       CGRectMake(kJVFieldHMargin, 0, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    self.nameTextView.placeholder = NSLocalizedString(@"Name", @"");
    self.nameTextView.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.nameTextView.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.nameTextView.floatingLabelTextColor = floatingLabelColor;
    self.nameTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextView.returnKeyType=UIReturnKeyNext;
    self.nameTextView.delegate=self;
    [self.headerView addSubview:self.nameTextView];
    [self.nameTextView becomeFirstResponder];
    
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin, self.nameTextView.frame.origin.y + self.nameTextView.frame.size.height,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    
    self.emailTextView=[[JVFloatLabeledTextField alloc]initWithFrame:CGRectMake(kJVFieldHMargin, div1.frame.origin.y + div1.frame.size.height,self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    self.emailTextView.placeholder = NSLocalizedString(@"E-mail", @"");
    self.emailTextView.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.emailTextView.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.emailTextView.floatingLabelTextColor = floatingLabelColor;
    self.emailTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextView.returnKeyType=UIReturnKeyDone;
    self.emailTextView.delegate=self;
    [self.headerView addSubview:self.emailTextView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text.length>0){
        [textField resignFirstResponder];
        if(textField==self.nameTextView){
            [self.emailTextView becomeFirstResponder];
        }
        if(self.nameTextView.text.length>0&&self.emailTextView.text.length>0){
            [self.saveButton setEnabled:YES];
        }
        return YES;
    }else{
        return NO;
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
