//
//  ContentSelectPerformanceStatsViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-28.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "PlayerData.h"
#import "UIView+Animation.h"


@interface ContentSelectPerformanceStatsViewController : UIViewController <MBProgressHUDDelegate>



@property (weak, nonatomic) IBOutlet UILabel *contentInfluenceLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentPicksLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentPctLabel;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UILabel *voteDaysLeftLabel;

@property (weak, nonatomic) IBOutlet UIButton *buybtn;

- (IBAction)buyContent:(id)sender;

@property (nonatomic,strong) PFObject *selectedparseobj;


@end
