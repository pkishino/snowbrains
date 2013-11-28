//
//  SpeedTestViewController.m
//  json
//
//  Created by Patrick Ziegler on 24/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "SpeedTestViewController.h"
#define posts @"http://snowbrains.com/?json=get_recent_posts&count=%@"

@interface SpeedTestViewController (){
    AFURLSessionManager *sessionManager;
    NSMutableArray *results;
    int loop;
    NSDate *start;
    NSDate *end;
    NSTimeInterval duration;
    NSURL *url;
    NSURLRequest *request;
    NSURLSessionDataTask *task;
    NSNumber *avg;
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
    sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    results=[NSMutableArray array];
//    results=[NSArray arrayWithObjects:@"10",@"15",@"20",@"25",@"30",@"35", nil];
//    for (NSString *i in results) {
//        [self setValue:i forKeyPath:[NSString stringWithFormat:@"label%d.text",[results indexOfObject:i]]];
//    }
    loop=1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startClick:(id)sender {
    for (int i=0; i<6; i++) {
        [results addObject:[self valueForKeyPath:[NSString stringWithFormat:@"label%d.text",i]]];
    }
    
    [self recurseData:0];
}

-(void)recurseData:(int)item{
    if(item!=6){
        start=[NSDate date];
        url = [NSURL URLWithString:[NSString stringWithFormat:posts,[results objectAtIndex:item]]];
        request = [NSURLRequest requestWithURL:url];
        
        task = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//            if (error) {
//                NSLog(@"Error: %@", error);
//            } else {
//                NSLog(@"%@ %@", response, responseObject);
//                
//            }
            end=[NSDate date];
            duration=[end timeIntervalSinceDate:start];
            
            avg=(NSNumber*)[self valueForKeyPath:[NSString stringWithFormat:@"result%d.text",item]];
            [self setValue:[NSString stringWithFormat:@"%.3f",duration] forKeyPath:[NSString stringWithFormat:@"result%d.text",item]];
            double average=avg.doubleValue;
            average+=((duration-average)/loop);
            [self setValue:[NSString stringWithFormat:@"%.3f",average] forKeyPath:[NSString stringWithFormat:@"avg%d.text",item]];
            
            [self recurseData:item+1];
        }];
        [task resume];
    }else{
        loop=loop+1;
        self.loopLabel.text=[NSString stringWithFormat:@"%d",loop];
        if (loop<=100) {
            [self recurseData:0];
        }
    }
}

@end
