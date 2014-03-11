//
//  LeaderboardsViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

//for now this will feature the top 100 users in each category in a simple leaderboard


#import <UIKit/UIKit.h>
#import <parse/parse.h>
#import "TopbarViewController.h"
#import "LeaderboardPFQueryTableViewController.h"

@class LeaderboardsViewController;

@protocol LeaderboardsViewControllerDelegate

@required
-(void) dismissLVC:(LeaderboardsViewController *) lvc;




@end




@interface LeaderboardsViewController : UIViewController <TopBarViewControllerDelegate>

@property (nonatomic, weak) id <LeaderboardsViewControllerDelegate> lvcdelegate;



@property (nonatomic,strong) IBOutlet UISegmentedControl * boardpick;

@property (nonatomic,strong) IBOutlet UIView *mytopbar;

@property (nonatomic,strong) IBOutlet UIView *stage;

-(IBAction)badgetypechoice:(id)sender;

-(IBAction)backbtnpress:(id)sender;


@end
