//
//  PlayerProfileViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgesViewController.h"
#import "LeaderboardsViewController.h"

@interface PlayerProgressViewController : UIViewController <BadgesViewControllerDelegate,LeaderboardsViewControllerDelegate,TopBarViewControllerDelegate>

-(IBAction) Badges:(id)sender;
-(IBAction) Leaderboard:(id)sender;
-(IBAction) Collections:(id)sender;

@property (strong,nonatomic) IBOutlet UIView *topbar;

@property (strong,nonatomic) IBOutlet UIButton *collectionsbtn;
@property (strong,nonatomic) IBOutlet UIButton *badgesbtn;
@property (strong,nonatomic) IBOutlet UIButton *leaderboardsbtn;

@property (strong,nonatomic) IBOutlet UILabel *collectionstext;
@property (strong,nonatomic) IBOutlet UILabel *badgestext;
@property (strong,nonatomic) IBOutlet UILabel *leaderboardstext;



@end
