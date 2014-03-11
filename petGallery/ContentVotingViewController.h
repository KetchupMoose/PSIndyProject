//
//  ContentVotingViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontPageSelectionViewcontroller.h"
#import "VSCollectionView.h"
#import "VoteScreenCollectionViewCell.h"
#import "VoteScreenCollectionView.h"
#import "VoteSummaryViewController.h"
#import "PopupViewController.h"
#import "UIView+Animation.h"
#import "WinParticleView.h"
#import "CelebrateParticleView.h"
#import "Emitter.h"
#import "WelcomeScreenViewController.h"
#import "NSMutableArray+NSMutableArrayShuffle.h"
#import "MBProgressHUD.h"
#import "InternetOfflineViewController.h"
#import "GoldStoreViewController.h"
#import <AdColony/AdColony.h>
#import "CategorySelectViewController.h"
#import "TestLoadViewController.h"
@interface ContentVotingViewController : UIViewController <UIScrollViewDelegate,VSCollectionViewDelegate,VSCollectionViewDataSource,FrontPageSelectionViewControllerDelegate,VoteScreenCollectionViewCellDelegate,VoteScreenCollectionViewDelegate,VoteSummaryViewControllerDelegate, PopupViewControllerDelegate,TopBarViewControllerDelegate,WelcomeScreenViewControllerDelegate,MBProgressHUDDelegate,GoldStoreViewControllerDelegate,CategorySelectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *stage;
@property (weak, nonatomic) IBOutlet UIView *topbarcontainer;

//-(IBAction) reportbtnpress:(id)sender;


@property (strong,nonatomic) NSMutableArray *contentObjectsArray;
@property (strong,nonatomic) NSMutableArray *categoryChallengeArray;


@end
