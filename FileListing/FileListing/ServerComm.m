//
//  ServerComm.m
//  FileListing
//
//  Created by Admin on 21/09/2016.
//  Copyright © 2016 a. All rights reserved.
//

#import "ServerComm.h"

@implementation FLServerComm

NSMutableArray *ret;

-(void) getData: (NSString *) urlS completion:(void (^)(NSMutableArray *, NSError *)) completionBlock
{
    NSURL *url = [NSURL URLWithString: urlS];
    
    NSURLSessionDataTask *content = [[NSURLSession sharedSession]
                                       dataTaskWithURL: url
                                     completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                     {
                                         void (^runAfterCompletion)(void) = ^void (void)
                                         {
                                             if(error)
                                             { NSLog(@"Oh Darn! Error trying to retrieve JSON! %@", error.localizedDescription); }
                                             else
                                             {
                                                 NSError *JSONError = nil;
                                             
                                                 NSMutableArray *mess = [NSJSONSerialization JSONObjectWithData: data
                                                                                                  options: 0
                                                                                                    error: &JSONError];
                                                 
                                                 if(JSONError)
                                                 { NSLog(@"Oh Darn! Error with serialization of JSON! %@", JSONError.localizedDescription); }
                                                 else
                                                 { completionBlock(mess, error); }
                                             }
                                         };
                                         dispatch_async(dispatch_get_main_queue(), runAfterCompletion);
                                     }];
    
    [content resume];
}

-(void)downloadData: (NSString *) urlS completion:(void (^)(NSData *, NSError *)) completionBlock
{
    NSURL *url = [NSURL URLWithString: urlS];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest: request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        void (^runAfterCompletion)(void) = ^void (void)
        {
            if(error)
            { NSLog(@"Oh Darn! Error trying to download! %@", error.localizedDescription); }
            else
            { completionBlock(data, error); }
        };
        dispatch_async(dispatch_get_main_queue(), runAfterCompletion);
    }];
    [downloadTask resume];
}

/** -(id)cleanJsonToObject:(id)data **/
/** From Stack Overflow             **/
/** Currently unused                **/
-(id)cleanJsonToObject:(id)data
{
    NSError* error;
    if (data == (id)[NSNull null])
    {
        return [[NSObject alloc] init];
    }
    id jsonObject;
    if ([data isKindOfClass:[NSData class]])
    {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    } else
    {
        jsonObject = data;
    }
    if ([jsonObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *array = [jsonObject mutableCopy];
        for (int i = (int)array.count-1; i >= 0; i--)
        {
            id a = array[i];
            if (a == (id)[NSNull null])
            {
                [array removeObjectAtIndex:i];
            } else
            {
                array[i] = [self cleanJsonToObject:a];
            }
        }
        return array;
    } else if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *dictionary = [jsonObject mutableCopy];
        for(NSString *key in [dictionary allKeys])
        {
            id d = dictionary[key];
            if (d == (id)[NSNull null])
            {
                dictionary[key] = @"";
            } else
            {
                dictionary[key] = [self cleanJsonToObject:d];
            }
        }
        return dictionary;
    } else
    {
        return jsonObject;
    }
}

@end
