//
//  VoteScreenCollectionViewCell.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PSCollectionViewCell.h"
#import <parse/parse.h>

@class VoteScreenCollectionViewCell;

@protocol VoteScreenCollectionViewCellDelegate <NSObject>

@optional
- (void)processButtonClick:(UIButton *)btnclicked atIndex:(NSInteger)index withHostView:(UIView *)thisview;


@end


@interface VoteScreenCollectionViewCell : PSCollectionViewCell

 @property (nonatomic,strong) IBOutlet UILabel *cellText;
 @property (nonatomic,strong) IBOutlet UIImageView *cellImage;
@property (nonatomic,strong) IBOutlet UIButton *voteButton;

@property (nonatomic, strong) UIButton *thevotebtn;
@property (nonatomic, strong) UILabel *thecelltxt;
@property (nonatomic, strong) UIImageView *theImgView;

@property (nonatomic, strong) id <VoteScreenCollectionViewCellDelegate> voteScreenCollectionViewCellDelegate;



- (IBAction)SelectVoteButton:(id)sender;

@end
