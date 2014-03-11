//
//  PlayerData.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-14.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <parse/parse.h>
#import "funData.h"

@class PlayerData;

@protocol PlayerDataDelegate

@optional
-(void)DoTimerTick:(NSUInteger) Time;


@end



@interface PlayerData : NSObject


@property (strong, nonatomic) NSNumber *playerscore;
@property (strong,nonatomic) NSNumber *playerTopScore;

@property (strong,nonatomic) NSNumber *usermaxhearts;
@property (strong,nonatomic) NSNumber *userXP;
@property (strong,nonatomic) NSNumber *nextXPRequired;
@property (strong,nonatomic) NSNumber *userGold;
@property (strong,nonatomic) NSNumber *userGems;
@property (strong,nonatomic) NSNumber *userLevel;

@property (strong,nonatomic) NSNumber *usercurrenthearts;

@property (strong,nonatomic) NSNumber *atmaxhearts;
@property (strong,nonatomic) NSNumber *progress;


@property (strong,nonatomic) NSNumber *levelupGoldReward;
@property (strong,nonatomic) NSNumber *levelupGemReward;
@property (strong,nonatomic) NSNumber *levelupHeartReward;

@property (strong,nonatomic) NSNumber * lossCost;

@property (strong,nonatomic) NSNumber *userInfluence;
@property (strong,nonatomic) NSNumber *userTotalInfluence;
@property (strong,nonatomic) NSNumber *userTotalCreatorInfluence;
@property (strong,nonatomic) NSNumber *userTotalChampionInfluence;
@property (strong,nonatomic) NSDate *lastCollectDate;
@property (strong,nonatomic) NSNumber *collectsRemaining;
@property (nonatomic) BOOL loadedhearttimedata;
@property (nonatomic) BOOL firstload;

@property (nonatomic, weak) id <PlayerDataDelegate> pddelegate;

-(void) getPlayerData;
-(void) setPlayerData;
-(float) RemoveHeart:(id) sender;
-(float) RefillHeart:(id) sender;
-(float) AddGoldXPScoreVote:(NSInteger) thegold withXP:(float) xp withScore:(NSInteger) score;
-(BOOL) spendUserGems:(NSInteger) gems;
-(void)LossCostIncrease:(NSNumber *) lcost;
-(BOOL) addUserInfluence:(NSInteger) influence withType:(NSInteger) inftype;
-(BOOL) addUserInfluenceOnCreate:(NSInteger) influence withType:(NSInteger) inftype;
-(void)LossCostReset;
+(id) sharedData;
-(void) CheckForRefresh;
-(void)doTimer:(NSUInteger) ticks;
-(void)reduceticks;
-(NSUInteger) getticknum;

@end
