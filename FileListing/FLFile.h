//
//  FLFile.h
//  FileListing
//
//  Created by Admin on 22/09/2016.
//  Copyright © 2016 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerComm.h"
#import <UIKit/UIKit.h>

@interface FLFile : NSObject

@property (readwrite) NSString *name;
@property (readwrite) NSString *type;
@property (readwrite) NSString *size;
@property (readwrite) NSString *mTime;

-(id)initWithParam: (NSString *) nameI;
-(void)getInfo: (NSString *) path;
-(void)download: (NSString *) path;

@end
