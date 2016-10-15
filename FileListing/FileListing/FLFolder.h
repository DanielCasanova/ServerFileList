//
//  FLFolder.h
//  FileListing
//
//  Created by Admin on 22/09/2016.
//  Copyright © 2016 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerComm.h"
#import "FLFile.h"

@interface FLFolder : NSObject
{
    NSMutableArray *subFolders;
    NSMutableArray *filesInFolder;
}

@property (readwrite) NSString *name;
@property (readwrite) NSString *path;
@property (readwrite) FLFolder *parent;

-(id)initWithParam: (NSString *) nameI path: (NSString *) pathI parent: (FLFolder *) parentI;
-(void)getContents;
-(NSString *)getFolderName: (NSUInteger) i;
-(NSString *)getFileName: (NSUInteger) i;
-(FLFile *)getFile: (NSUInteger) i;
-(NSUInteger) getFolderCount;
-(NSUInteger) getFilesCount;
-(FLFolder *) getFolder: (NSUInteger) i;

@end
