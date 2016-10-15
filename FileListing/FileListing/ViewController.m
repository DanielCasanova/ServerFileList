//
//  ViewController.m
//  FileListing
//
//  Created by Admin on 21/09/2016.
//  Copyright © 2016 a. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

FLFolder *topLevel;
FLFolder *currentLoc;
NSInteger size1, size2;

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setup];
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:@"gotContent"
                                               object:nil];
    
    topLevel = [[FLFolder alloc] initWithParam:@"topLevel" path:@"" parent: NULL];
    size1 = size2 = 0;
    [topLevel getContents];
    currentLoc = topLevel;
}

-(void)reload: (NSNotification *) notification
{
    size1 = [currentLoc getFolderCount];
    size2 = [currentLoc getFilesCount];
    
    [self.tableView reloadData];
}

-(void)update
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:@"gotContent"
                                               object:nil];
    
    [currentLoc getContents];
}

-(NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    if(currentLoc.parent == NULL)
    { return size1 + size2; }
    else
    { return size1 + size2 + 1; }
}

-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSUInteger i = indexPath.row;
    
    if(currentLoc.parent != NULL && indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed: @"folderIco.png"];
        cell.textLabel.text = @"..";
        cell.detailTextLabel.text = [NSString stringWithFormat: @""];
        
        return cell;
    }
    
    if(currentLoc.parent != NULL)
    { i--; }
    
    if(size1 > i)
    {
        cell.imageView.image = [UIImage imageNamed: @"folderIco.png"];
        cell.textLabel.text = [currentLoc getFolderName: i];
        cell.detailTextLabel.text = [NSString stringWithFormat: @""];
        
        return cell;
    }
    else
    {
        FLFile *aux = [currentLoc getFile: i-size1];
        cell.imageView.image = [UIImage imageNamed: @"fileIco.png"];
        cell.textLabel.text = aux.name;
        cell.detailTextLabel.text = aux.type;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    
    if(currentLoc.parent != NULL)
    { i--; }
    
    if(size1 > i)
    {
        if(currentLoc.parent != NULL && indexPath.row == 0)
        {
            currentLoc = currentLoc.parent;
            [self update];
        }
        else
        {
            currentLoc = [currentLoc getFolder: i];
            [self update];
        }
    }
    else
    {
        FLFile *aux = [currentLoc getFile: i-size1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: aux.name
                                                                       message: [NSString stringWithFormat: @"File Type: %@\nFile size: %@", aux.type, aux.size]
                                                                preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open"
                                                                style: UIAlertActionStyleDefault
                                                              handler: ^(UIAlertAction * action) { [aux download: currentLoc.path]; } ];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style: UIAlertActionStyleDefault
                                                           handler: ^(UIAlertAction * action) {} ];
        
        [alert addAction: openAction];
        [alert addAction: cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
