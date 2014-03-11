//
//  FrontPagePFQueryTableViewController.h
//  petGallery
//
//  Created by mac on 7/25/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <Parse/Parse.h>
#import "FrontPageSelectionViewController.h"


@interface FrontPagePFQueryTableViewController : PFQueryTableViewController <FrontPageSelectionViewControllerDelegate>
@property (nonatomic, retain) PFQuery *frontPageQuery;

@end
