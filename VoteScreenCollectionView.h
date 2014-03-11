//
//  VoteScreenCollectionView.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-21.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "VSCollectionView.h"
#import <UIKit/UIKit.h>
#import <parse/parse.h>
#import "FrontPageSelectionViewController.h"
#import "VoteScreenCollectionViewCell.h"

@class VoteScreenCollectionView;

@protocol VoteScreenCollectionViewDelegate <NSObject>

@required
- (void)VoteScreenNewVote:(VoteScreenCollectionView *)collectionView voteIndex:(NSInteger)index;
- (void)displayVoteFave:(VoteScreenCollectionView *)collectionView;
- (void)displayGuessNow:(VoteScreenCollectionView *)collectionView;
- (void)getNextData:(VoteScreenCollectionView *)collectionView;
- (void)getNextChallenge:(NSString *)winorfail;
- (NSArray *)getChallengeVotes:(VoteScreenCollectionView *) vscv;
- (void) showSummaryScreen:(VoteScreenCollectionView *) vscv withWinMode:(NSInteger) winmode withChoice:(NSInteger) choice;
-(void) showoutofhearts;

@end


@interface VoteScreenCollectionView : VSCollectionView <FrontPageSelectionViewControllerDelegate,VoteScreenCollectionViewCellDelegate>

//this is the function to get it to query data and load
- (void)queryforData;

@property (strong,nonatomic) NSMutableArray *vscontentObjectsArray;
@property (strong,nonatomic) PFQuery *querytouse;

@property (strong,nonatomic) NSMutableArray *vschallengeVotes;

@property (strong,nonatomic) NSNumber *challengeIndexNSNumber;
@property (strong,nonatomic) NSNumber *vschallengeMode;


@property (nonatomic, strong) id <VoteScreenCollectionViewDelegate> vscollectionViewDelegate;

-(void) addFrames:(UIView *) addview;

@end
