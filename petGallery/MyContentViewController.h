//
//  MyContentViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-02.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarViewController.h"
#import "MyPetsQueryTableViewController.h"
#import "PlayerData.h"

@class MyContentViewController;

@protocol MyContentViewControllerDelegate

-(void) dismissMyContentScreen:(MyContentViewController *)controller;


@end



@interface MyContentViewController : UIViewController <TopBarViewControllerDelegate,MyPetsQueryTableViewControllerDelegate>




@property (weak, nonatomic) IBOutlet UIView *contenttableview;
@property (weak, nonatomic) IBOutlet UIView *topbararea;

@property (nonatomic, weak) id <MyContentViewControllerDelegate> mycontentdelegate;
@property (strong,nonatomic) NSString *DisplayMode;
-(IBAction) back:(id) sender;

@property (weak, nonatomic) IBOutlet UILabel *collectsRemainLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreInLabel;

@end
