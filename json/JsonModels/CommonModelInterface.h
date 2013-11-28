//
//  CommonInterface.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "JSONModel.h"

@interface CommonModelInterface : JSONModel

@property (nonatomic, retain) NSNumber<Optional> *oID;

-(id)saveToCore;

@end
