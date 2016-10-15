//
//  FLFolder.m
//  FileListing
//
//  Created by Admin on 22/09/2016.
//  Copyright © 2016 a. All rights reserved.
//

#import "FLFolder.h"

@implementation FLFolder

@synthesize name;
@synthesize path;
@synthesize parent;

-(id)initWithParam: (NSString *) nameI path: (NSString *) pathI parent: (FLFolder *) parentI
{
    name = nameI;
    path = pathI;
    parent = parentI;
    
    subFolders = [[NSMutableArray alloc] init] ;
    filesInFolder = [[NSMutableArray alloc] init];
    
    return self;
}

-(void)getContents
{
    FLServerComm *comms = [[FLServerComm alloc] init];
    
    NSString *url = [NSString stringWithFormat: @"http://78.47.69.190/getFilesFromFolder.php?type=folders&path=%@", path];
    
    [comms getData: url
        completion: ^(NSMutableArray *arr, NSError *error)
         {
             if(error)
             { NSLog(@"Oh Darn! Error retrieving folders from server!\n %@", error.localizedDescription); }
             else
             {
                 [subFolders removeAllObjects];
                 
                 for(NSString *str in arr)
                 {
                     FLFolder *newF = [[FLFolder alloc] initWithParam: str path: [NSString stringWithFormat: @"%@%@/", path, str] parent: self];
                     [subFolders addObject: newF];
                 }
                 [self getFiles];
             }
         }];
}

-(void)getFiles
{
    FLServerComm *comms = [[FLServerComm alloc] init];
    
    NSString *url = [NSString stringWithFormat: @"http://78.47.69.190/getFilesFromFolder.php?type=files&path=%@", path];
    NSLog(@"\n\n\nURL: %@\n\n\n", url);
    
    [comms getData: url
        completion: ^(NSMutableArray *arr, NSError *error)
     {
         if(error)
         { NSLog(@"Oh Darn! Error retrieving files from server!\n %@", error.localizedDescription); }
         else
         {
             [filesInFolder removeAllObjects];
             
             for(NSString *str in arr)
             {
                 FLFile *newF = [[FLFile alloc] initWithParam: str];
                 [newF getInfo: path];
                 [filesInFolder addObject: newF];
             }
         }
         NSNotification *note = [NSNotification notificationWithName: @"gotContent" object: self];
         [[NSNotificationCenter defaultCenter] postNotification: note];
     }];
}

-(NSString *)getFolderName: (NSUInteger) i
{ return [[subFolders objectAtIndex: i] name]; }

-(NSString *)getFileName: (NSUInteger) i
{ return [[filesInFolder objectAtIndex: i] name]; }

-(FLFile *)getFile: (NSUInteger) i
{ return [filesInFolder objectAtIndex: i]; }

-(NSUInteger) getFolderCount
{ return [subFolders count]; }

-(NSUInteger) getFilesCount
{ return [filesInFolder count]; }

-(FLFolder *) getFolder: (NSUInteger) i
{ return [subFolders objectAtIndex: i]; }

@end
