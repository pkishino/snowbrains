//
//  ImageModel.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommonModelInterface.h"
#import "ImageDataModel.h"

@interface ImageModel : CommonModelInterface

@property (strong, nonatomic) ImageDataModel* thumbnail;
@property (strong, nonatomic) ImageDataModel* full;
@property (strong, nonatomic) ImageDataModel* large;
@property (strong, nonatomic) ImageDataModel* medium;

@end
