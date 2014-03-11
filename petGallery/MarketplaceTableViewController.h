//
//  MarketplaceTableViewController.h
//  petGallery
//
//  Created by mac on 6/25/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MarketplaceTableViewController : UITableViewController
- (IBAction)refreshmarket:(id)sender;

@property (nonatomic, strong) NSMutableArray *pets;
@end
