//
//  DTWebVideoView+SnowBrains.m
//  json
//
//  Created by Patrick Ziegler on 7/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "DTWebVideoView+SnowBrains.h"

@implementation DTWebVideoView (SnowBrains)
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	// allow the embed request for YouTube
	if (NSNotFound != [[[request URL] absoluteString] rangeOfString:@"www.youtube.com/embed/"].location)
	{
		return YES;
	}
    
	// allow the embed request for DailyMotion Cloud
	if (NSNotFound != [[[request URL] absoluteString] rangeOfString:@"api.dmcloud.net/player/embed/"].location)
	{
		return YES;
	}
    if (NSNotFound != [[[request URL] absoluteString] rangeOfString:@"player.vimeo.com/video"].location)
	{
		return YES;
	}
    
	BOOL shouldOpenExternalURL = NO;
	
	if (shouldOpenExternalURL)
	{
		[[UIApplication sharedApplication] openURL:[request URL]];
	}
	
	return NO;
}

@end
