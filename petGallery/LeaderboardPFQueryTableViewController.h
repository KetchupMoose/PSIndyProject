//
//  LeaderboardPFQueryTableViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"
@interface LeaderboardPFQueryTableViewController : PFQueryTableViewController

@property (nonatomic,strong) PFQuery *querytouse;

@property (nonatomic,strong) NSNumber *leaderMode;

@end
