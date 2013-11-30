//
//  SpeedTestViewController.m
//  json
//
//  Created by Patrick Ziegler on 24/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "SpeedTestViewController.h"
#define jsonNative @"http://snowbrains.com/?json=get_recent_posts&count=%@"
#define jsonJetpack @"http://public-api.wordpress.com/rest/v1/sites/61111509/posts/?number=%@"
@interface SpeedTestViewController (){
    AFURLSessionManager *sessionManager;
    NSMutableArray *results;
    int loop;
    int errorCount;
    NSDate *start;
    NSDate *end;
    NSTimeInterval duration;
    NSURL *url;
    NSMutableURLRequest *request;
    NSURLSessionDataTask *task;
    NSNumber *avg;
    NSInteger keyboardHeight;
    NSString * posts;
    BOOL stopped;
}

@end

@implementation SpeedTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setHTTPAdditionalHeaders:[NSDictionary dictionaryWithObjectsAndKeys:@"gzip, deflate",@"Accept-Encoding", nil] ];
    sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    results=[NSMutableArray array];
    loop=1;
    for (int i=0; i<6; i++) {
        [(UITextField*)[self valueForKeyPath:[NSString stringWithFormat:@"label%d",i]] setDelegate:self];
    }
    [self.loopCount setDelegate:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startClick:(id)sender {
    [self.startButton setEnabled:NO];
    [self.jsonType setEnabled:NO];
    [self.loopCount setEnabled:NO];
    [results removeAllObjects];
    for (int i=0; i<6; i++) {
        NSNumber *value=[self valueForKeyPath:[NSString stringWithFormat:@"label%d.text",i]];
        [results addObject:value.intValue>=1?value:[NSNumber numberWithInt:1]];
        [self setValue:nil forKeyPath:[NSString stringWithFormat:@"avg%d.text",i]];
    }
    if(!self.loopCount.text.intValue>=1){
        self.loopCount.text=@"1";
    }
    posts=self.jsonType.selectedSegmentIndex==0?jsonNative:jsonJetpack;
    errorCount=0;
    stopped=NO;
    [self recurseData:0];
}

-(void)recurseData:(int)item{
    if (stopped) {
        return;
    }
    if(item!=6){
        start=[NSDate date];
        url = [NSURL URLWithString:[NSString stringWithFormat:posts,[results objectAtIndex:item]]];
        request = [NSURLRequest requestWithURL:url];
        
        task = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if(!error){
            end=[NSDate date];
            duration=[end timeIntervalSinceDate:start];
            
            avg=(NSNumber*)[self valueForKeyPath:[NSString stringWithFormat:@"result%d.text",item]];
            [self setValue:[NSString stringWithFormat:@"%.3f",duration] forKeyPath:[NSString stringWithFormat:@"result%d.text",item]];
            double average=avg.doubleValue;
            average+=((duration-average)/loop);
            [self setValue:[NSString stringWithFormat:@"%.3f",average] forKeyPath:[NSString stringWithFormat:@"avg%d.text",item]];
            }else{
                self.errorLabel.text=[NSString stringWithFormat:@"%d",errorCount];
            }
            [self recurseData:item+1];
        }];
        [task resume];
    }else{
        loop=loop+1;
        self.loopLabel.text=[NSString stringWithFormat:@"%d",loop-1];
        if (loop<=self.loopCount.text.intValue) {
            [self recurseData:0];
        }else{
            [self.startButton setEnabled:YES];
            [self.jsonType setEnabled:YES];
            [self.loopCount setEnabled:YES];
            loop=1;
        }
    }
}
-(IBAction)stopClicked:(id)sender{
    stopped=YES;
    [task cancel];
    [self.startButton setEnabled:YES];
    [self.jsonType setEnabled:YES];
    [self.loopCount setEnabled:YES];
    loop=1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
    });
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSInteger viewFrameHeight = self.view.frame.size.height;
    NSInteger textFieldRelativePosition =textField.frame.origin.y+textField.frame.size.height;
    NSInteger textFieldFrameOffset = viewFrameHeight - textFieldRelativePosition;
    NSInteger movement = MAX(0,216-textFieldFrameOffset); // Offset from where the keyboard will appear.

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.view.frame = CGRectMake(0,-movement,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height);
        [UIView commitAnimations];
    });

}

- (NSInteger)getKeyBoardHeight:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSInteger height = keyboardFrameBeginRect.size.height;
    return height;
}

-(void) keyboardDidShow:(NSNotification*) notification
{
    keyboardHeight = [self getKeyBoardHeight:notification];
}

@end
