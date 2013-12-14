//
//  JsonViewController.m
//  json
//
//  Created by Patrick Ziegler on 13/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "JsonViewController.h"
#import "HttpRequests.h"

@interface JsonViewController ()

@end

@implementation JsonViewController

- (IBAction)beforePressed:(id)sender {
    NSDictionary *after=[NSDictionary dictionaryWithObject:[self getDateDictionary] forKey:@"before"];
    NSDictionary *complete=[NSDictionary dictionaryWithObjectsAndKeys:@"get_posts",@"json",after,@"date_query",@"10",@"count", nil];
    [HttpRequests getJson:complete andCompletion:^(BOOL success, NSError *error, id responseObject) {
        self.output.text=((NSDictionary*)responseObject).description;
    }];
}
- (IBAction)thisDatePressed:(id)sender {
    NSDictionary *complete=[NSDictionary dictionaryWithObjectsAndKeys:[self getDateDictionary],@"date_query",@"get_posts",@"json", nil];
    [HttpRequests getJson:complete andCompletion:^(BOOL success, NSError *error, id responseObject) {
        self.output.text=((NSDictionary*)responseObject).description;
    }];
}
- (IBAction)afterDatePressed:(id)sender {
    NSDictionary *after=[NSDictionary dictionaryWithObject:[self getDateDictionary] forKey:@"after"];
    NSDictionary *complete=[NSDictionary dictionaryWithObjectsAndKeys:@"get_posts",@"json",after,@"date_query", nil];
    [HttpRequests getJson:complete andCompletion:^(BOOL success, NSError *error, id responseObject) {
        self.output.text=((NSDictionary*)responseObject).description;
    }];
}
-(NSDictionary*)getDateDictionary{
    if(self.date.date){
        NSString *dateString=[NSDateFormatter localizedStringFromDate:self.date.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        NSArray* dateParts=[dateString componentsSeparatedByString:@"/"];
        return [NSDictionary dictionaryWithObjectsAndKeys:dateParts[0],@"day",dateParts[1],@"month",dateParts[2],@"year", nil];
    }
    return nil;
}

@end
