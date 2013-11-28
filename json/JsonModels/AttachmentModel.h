//
//  AttachmentModel.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommonModelInterface.h"
#import "ImageModel.h"

@interface AttachmentModel : CommonModelInterface

@property (assign, nonatomic) int parent;

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString<Optional>* objectDescription;
@property (strong, nonatomic) NSString* slug;
@property (strong, nonatomic) NSString* mime_type;
@property (strong, nonatomic) NSString<Optional>* caption;
@property (strong, nonatomic) NSString* url;

@property (strong, nonatomic) ImageModel<Optional>* images;

@end
