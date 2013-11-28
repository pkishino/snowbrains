//
//  ImageDataModel.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommonModelInterface.h"

@interface ImageDataModel : CommonModelInterface

@property (assign, nonatomic) int height;
@property (assign, nonatomic) int width;

@property (strong, nonatomic) NSString* url;

@end
