//
//  LossScreenViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerData.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "InternetOfflineViewController.h"
#import "GoldStoreViewController.h"

@class LossScreenViewController;

@protocol LossScreenViewControllerDelegate <NSObject>

@required
- (void)closeButtonClick:(LossScreenViewController *) thiscontroller;
- (void)continueButtonClick:(LossScreenViewController *) thiscontroller withGems:(NSNumber *) gems;

@end





@interface LossScreenViewController : UIViewController<GoldStoreViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *friendName1;
@property (weak, nonatomic) IBOutlet UILabel  *friendName2;
@property (weak, nonatomic) IBOutlet UILabel  *friendName3;
@property (weak, nonatomic) IBOutlet UILabel  *friendScore1;
@property (weak, nonatomic) IBOutlet UILabel  *friendScore2;
@property (weak, nonatomic) IBOutlet UILabel  *friendScore3;
@property (weak, nonatomic) IBOutlet UILabel  *YouLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel  *ScoreTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel  *ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel  *BestScoreTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel  *BestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel  *LeaderboardLabel;
@property (weak, nonatomic) IBOutlet UILabel  *friendRank1;
@property (weak, nonatomic) IBOutlet UILabel  *friendRank2;
@property (weak, nonatomic) IBOutlet UILabel  *friendRank3;


@property (weak, nonatomic) IBOutlet UIButton *myallBtn;
@property (weak, nonatomic) IBOutlet UIButton *myFriendsBtn;
@property (weak, nonatomic) IBOutlet UIButton *myContinueBtn;
@property (weak, nonatomic) IBOutlet UIButton *myCloseBtn;

@property (weak, nonatomic) IBOutlet UIImageView  *friendImage1;
@property (weak, nonatomic) IBOutlet UIImageView  *friendImage2;
@property (weak, nonatomic) IBOutlet UIImageView  *friendImage3;

@property (weak, nonatomic) IBOutlet UIImageView  *bgImageView;

@property (strong,nonatomic) NSNumber *gemsForContinue;
@property (strong,nonatomic) NSNumber *LossScreenPlayerScore;
@property (strong,nonatomic) NSNumber *LossScreenPlayerTopScore;

-(IBAction)ContinueBtn:(id)sender;
-(IBAction)CloseBtn:(id) sender;
-(IBAction)AllBtn:(id) sender;
-(IBAction)FriendsBtn:(id)sender;

@property (weak,nonatomic) id <LossScreenViewControllerDelegate> lsdelegate;


@end
