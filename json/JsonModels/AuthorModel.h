//
//  AuthorModel.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommonModelInterface.h"

@interface AuthorModel : CommonModelInterface

@property (strong, nonatomic) NSString<Optional>* first_name;
@property (strong, nonatomic) NSString<Optional>* nickname;
@property (strong, nonatomic) NSString<Optional>* objectDescription;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString<Optional>* last_name;
@property (strong, nonatomic) NSString* slug;
@property (strong, nonatomic) NSString<Optional>* url;

@end
