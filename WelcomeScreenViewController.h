//
//  WelcomeScreenViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-29.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopbarViewController.h"


@class WelcomeScreenViewController;

@protocol WelcomeScreenViewControllerDelegate <NSObject>

@required
- (void)PlayBtnClick:(WelcomeScreenViewController *) thiscontroller;
- (void)StartLoadingData:(WelcomeScreenViewController *) thiswvc;


@end




@interface WelcomeScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView  *bgImage;
@property (weak,nonatomic) IBOutlet UIImageView *logoImage;
@property (weak,nonatomic) IBOutlet UIImageView *imgurLogo;
@property (weak, nonatomic) IBOutlet UIButton  *startvotebtn;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *featurefrom;

-(IBAction)statvote:(id)sender;

@property (weak,nonatomic) id <WelcomeScreenViewControllerDelegate> wsdelegate;


@end
