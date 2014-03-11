//
//  LevelUpViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-07.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebrateParticleView.h"

@class LevelUpViewController;

@protocol LevelUpViewControllerDelegate

@required

-(void)dismisslevelup:(LevelUpViewController *)controller;


@end



@interface LevelUpViewController : UIViewController

@property (nonatomic, weak) id <LevelUpViewControllerDelegate> lvlupdelegate;
-(void) levelupclosebutton:(id) sender;

@property (nonatomic,strong) NSNumber *lvlupgold;
@property (nonatomic,strong) NSNumber *lvluplevel;
@property (nonatomic,strong) NSNumber *lvlupgems;
@property (nonatomic,strong) NSNumber *lvlupheart;


@end
