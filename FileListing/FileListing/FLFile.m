//
//  FLFile.m
//  FileListing
//
//  Created by Admin on 22/09/2016.
//  Copyright © 2016 a. All rights reserved.
//

#import "FLFile.h"

@implementation FLFile

@synthesize name;
@synthesize type;
@synthesize size;
@synthesize mTime;

-(id)initWithParam: (NSString *) nameI
{
    name = nameI;
    
    return self;
}

-(void)getInfo: (NSString *) path
{
    FLServerComm *comms = [[FLServerComm alloc] init];

    NSString *url = [NSString stringWithFormat: @"http://78.47.69.190/getFileInfo.php?path=%@%@", path, name];

    [comms getData: url
        completion: ^(NSMutableArray *arr, NSError *error)
         {
             if(error)
             { NSLog(@"Oh Darn! Error retrieving files from server!\n %@", error.localizedDescription); }
             else
             {
                 type = [arr objectAtIndex: 0];
                 size = [arr objectAtIndex: 1];
                 mTime = [arr objectAtIndex: 2];
             }
         }];
}

-(void)download: (NSString *) path
{
    FLServerComm *comms = [[FLServerComm alloc] init];
    
    NSString *url = [NSString stringWithFormat: @"http://78.47.69.190/getFile.php?path=%@%@", path, name];
    
    [comms downloadData: url
             completion: ^(NSData *data, NSError *error)
            {
                if(error)
                { NSLog(@"Oh Darn! Error retrieving folders from server!\n %@", error.localizedDescription); }
                else
                {
                    [data writeToFile: [NSString stringWithFormat: @"/Users/admin/Desktop/%@", name] atomically:YES];
                    NSURL *res = [NSURL fileURLWithPath: [NSString stringWithFormat: @"/Users/admin/Desktop/%@", name]];
                    [[UIApplication sharedApplication] openURL: res options:@{} completionHandler:nil];
                }
            }];
}

@end
