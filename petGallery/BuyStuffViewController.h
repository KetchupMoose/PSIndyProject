//
//  BuyStuffViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketScreenViewController.h"
#import "MyContentViewController.h"
#import "TopBarViewController.h"
#import "GoldStoreViewController.h"


@interface BuyStuffViewController : UIViewController <MarketScreenViewControllerDelegate, MyContentViewControllerDelegate,TopBarViewControllerDelegate,GoldStoreViewControllerDelegate>



-(IBAction) BuyGold:(id)sender;
-(IBAction) BuyContent:(id)sender;
-(IBAction) ViewContent:(id)sender;

@property (strong,nonatomic) IBOutlet UIView *thetopbar;
@property (strong,nonatomic) IBOutlet UILabel *buygoldtext;
@property (strong,nonatomic) IBOutlet UILabel *browsecontenttext;
@property (strong,nonatomic) IBOutlet UILabel *mycontenttext;

@property (strong,nonatomic) IBOutlet UIButton *buygoldbtn;
@property (strong,nonatomic) IBOutlet UIButton *browseContentbtn;
@property (strong,nonatomic) IBOutlet UIButton *viewMyContentbtn;


@end
