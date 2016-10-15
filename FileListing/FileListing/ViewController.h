//
//  ViewController.h
//  FileListing
//
//  Created by Admin on 21/09/2016.
//  Copyright © 2016 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFolder.h"
#import "FLFile.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

