//
//  MarketplaceQueryTableViewController.h
//  petGallery
//
//  Created by mac on 6/28/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <Parse/Parse.h>
#import "BuyPetViewController.h"
#import "UIImageView+WebCache.h"
#import "MyPetCollectUIButton.h"
#import "PlayerData.h"
#import "MBProgressHUD.h"
#import "UIView+Animation.h"
#import "FrontPageSelectionViewController.h"

@class MarketplaceQueryTableViewController;

@protocol MarketplaceQueryTableViewControllerDelegate

@optional
-(void) dismissMQTVC:(MarketplaceQueryTableViewController *)controller;
-(void) updateTopNums;

@end

@interface MarketplaceQueryTableViewController:PFQueryTableViewController <BuyPetViewControllerDelegate,MBProgressHUDDelegate,FrontPageSelectionViewControllerDelegate>
{
    MBProgressHUD *HUD;
}

- (IBAction)refreshbutton:(id)sender;
//@property (strong, nonatomic) IBOutlet UITableView *MarketplaceTableView;

@property (nonatomic, strong) NSMutableArray *pets;

@property (nonatomic, weak) id <MarketplaceQueryTableViewControllerDelegate> mqdelegate;

@property (nonatomic,strong) PFQuery *querytouse;


@end
