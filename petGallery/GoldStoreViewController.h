//
//  GoldStoreViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopbarViewController.h"
#import <AdColony/AdColony.h>
#import "MainLoadTabBarController.h"
#import "MBProgressHUD.h"

@class GoldStoreViewController;

@protocol GoldStoreViewControllerDelegate

@required
- (void)BackToBuyStuff:
(GoldStoreViewController *)controller;


@end

@interface GoldStoreViewController : UIViewController <TopBarViewControllerDelegate,AdColonyDelegate,MBProgressHUDDelegate>


@property (strong,nonatomic) IBOutlet UIView *thetopbar;
@property (strong,nonatomic) IBOutlet UILabel *price1text;
@property (strong,nonatomic) IBOutlet UILabel *value1text;
@property (strong,nonatomic) IBOutlet UILabel *price2text;
@property (strong,nonatomic) IBOutlet UILabel *value2text;
@property (strong,nonatomic) IBOutlet UILabel *price3text;
@property (strong,nonatomic) IBOutlet UILabel *value3text;
@property (strong,nonatomic) IBOutlet UILabel *price4text;
@property (strong,nonatomic) IBOutlet UILabel *value4text;
@property (strong,nonatomic) IBOutlet UILabel *price5text;
@property (strong,nonatomic) IBOutlet UILabel *value5text;
@property (strong,nonatomic) IBOutlet UILabel *price6text;
@property (strong,nonatomic) IBOutlet UILabel *value6text;

@property (strong,nonatomic) IBOutlet UIImageView *storebackground;
@property (strong,nonatomic) IBOutlet UIImageView *priceicon1;
@property (strong,nonatomic) IBOutlet UIImageView *priceicon2;
@property (strong,nonatomic) IBOutlet UIImageView *priceicon3;
@property (strong,nonatomic) IBOutlet UIImageView *priceicon4;
@property (strong,nonatomic) IBOutlet UIImageView *priceicon5;
@property (strong,nonatomic) IBOutlet UIImageView *priceicon6;

@property (strong,nonatomic) IBOutlet UISegmentedControl *golddiamondswitch;

-(IBAction) PressPrice1:(id) sender;
-(IBAction) PressPrice2:(id) sender;
-(IBAction) PressPrice3:(id) sender;
-(IBAction) PressPrice4:(id) sender;
-(IBAction) PressPrice5:(id) sender;
-(IBAction) PressPrice6:(id) sender;

-(IBAction) PressPriceFree:(id) sender;

-(IBAction) PressSwitchGoldDiamond:(id) sender;

@property (nonatomic, weak) id <GoldStoreViewControllerDelegate> goldstoredelegate;

-(IBAction) BackToBuyStuffScreen:(id) sender;

-(void) setPricesAndValues;
- (void)getIAPData;
@end
