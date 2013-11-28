//
//  CategoryModel.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommonModelInterface.h"

@interface CategoryModel : CommonModelInterface

@property (assign, nonatomic) int post_count;
@property (assign, nonatomic) int parent;

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString<Optional>* objectDescription;
@property (strong, nonatomic) NSString* slug;


@end
