//
//  ServerComm.h
//  FileListing
//
//  Created by Admin on 21/09/2016.
//  Copyright © 2016 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLServerComm : NSObject

-(void)getData: (NSString *) urlS completion:(void (^)(NSMutableArray *, NSError *)) completionBlock;
-(void)downloadData: (NSString *) urlS completion:(void (^)(NSData *, NSError *)) completionBlock;

@end
