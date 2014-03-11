//
//  VoteSummaryViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-22.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <parse/parse.h>
#import "UIView+Animation.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "TopbarViewController.h"
#import "LossScreenViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@class VoteSummaryViewController;

@protocol VoteSummaryViewControllerDelegate <NSObject>

@required
- (void)dismissSummaryForNextContent:(VoteSummaryViewController *)summaryView;

@end

@interface VoteSummaryViewController : UIViewController <AVAudioPlayerDelegate,TopBarViewControllerDelegate,LevelUpViewControllerDelegate,LossScreenViewControllerDelegate>






@property IBOutlet UIView *topbar;

@property IBOutlet UIView * imagearea;

@property IBOutlet UIButton * nextBtn;

@property (strong) AVAudioPlayer *reactionSound;

- (IBAction)ToNextContentBtn:(id)sender;

@property (nonatomic, strong) id <VoteSummaryViewControllerDelegate> vsSummaryDelegate;

//needs a set of properties for:
//four images
//four vote counts
//win mode or fail mode

//for now I am getting the four images again by reloading PF Images...later this should be optimized.

@property (strong,nonatomic) NSMutableArray *contentobjs;
@property (strong,nonatomic) NSMutableArray *votecounts;
@property (strong,nonatomic) NSNumber *WinorFailMode;
@property (strong,nonatomic) NSNumber *winsinarow;
@property (strong,nonatomic) NSNumber *vsummarychallengeIndexNSNumber;

@property (strong,nonatomic) TopBarViewController *tpvc;
@property (strong,nonatomic) NSNumber *justappeared;
@property (strong,nonatomic) NSNumber *chosenobj;



@end
