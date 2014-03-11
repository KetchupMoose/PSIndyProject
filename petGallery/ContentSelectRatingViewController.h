//
//  ContentSelectRatingViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-10.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <parse/parse.h>
#import "PlayerData.h"
#import "MBProgressHUD.h"

@interface ContentSelectRatingViewController : UIViewController <MBProgressHUDDelegate>


@property (weak,nonatomic) PFObject * selectedContent;


@property (strong,nonatomic) IBOutlet UILabel *ratingHeaderLabel;


@property (strong, nonatomic) IBOutlet UISlider *ratingSlider;

- (IBAction)ratingSliderPick:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UIButton *ratingSendBtn;

- (IBAction)ratingbuttonpress:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *ratingImgView;


@end
