//
//  TopBarViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-09.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelUpviewController.h"
#import "PlayerData.h"

@class TopBarViewController;

@protocol TopBarViewControllerDelegate

@optional

-(void) showalevelup:(NSNumber *) lvl withGold:(NSNumber *) gold withGems:(NSNumber *) gems withHearts:(NSNumber *) hearts;

@end


@interface TopBarViewController : UIViewController <LevelUpViewControllerDelegate,PlayerDataDelegate>


@property (weak, nonatomic) IBOutlet UIButton *levelbutton;
- (IBAction)levelbuttonclick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *xpbarbutton;

@property (weak, nonatomic) IBOutlet UIButton *goldbutton;

@property (weak,nonatomic) IBOutlet UIView *heartsview;


@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UILabel *gemsLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *leveltitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *influenceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *xpBarStar;

@property (weak,nonatomic) IBOutlet UILabel *heartTimer;




-(float) RemoveHeartTopBar:(id) sender;
-(void) RefillHeartTopBar:(id) sender;
-(void) AddGoldTopBar:(NSInteger) thegold;
-(void) AddXPTopBar:(id) sender;
- (void) moveXPBar: (float) progress;
-(void) AddScore:(int) scoreAdd;
-(void)handleTimerTick;

-(void)updateLabel;
-(void) setLabels;
-(void) TopBarRefreshLabels;
@property (nonatomic, weak) id <TopBarViewControllerDelegate> topbardelegate;

@end
