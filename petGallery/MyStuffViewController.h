//
//  MyStuffViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddContentViewController.h"
#import "MyContentViewController.h"
#import "TopBarViewController.h"
#import "SearchResultsViewController.h"
#import <Parse/Parse.h>
#import "PlayerData.h"
#import "PopupViewController.h"
#import "MainLoadTabBarController.h"

@interface MyStuffViewController : UIViewController <AddContentViewControllerDelegate,MyContentViewControllerDelegate,TopBarViewControllerDelegate,SearchResultsViewControllerDelegate,PopupViewControllerDelegate>


-(IBAction) SubmitNew:id;
-(IBAction) ViewSubmissions:id;
-(IBAction) ViewFaves:(id)sender;
-(IBAction) ChangeMusic:(id)sender;


@property (strong,nonatomic) IBOutlet UIView *thetopbar;
@property (strong,nonatomic) IBOutlet UILabel *mysubmissionstext;
@property (strong,nonatomic) IBOutlet UILabel *submitnewtext;
@property (strong,nonatomic) IBOutlet UILabel *myfavoritestext;

@property (strong,nonatomic) IBOutlet UIButton *submitnewbtn;
@property (strong,nonatomic) IBOutlet UIButton *viewmysubmitsbtn;
@property (strong,nonatomic) IBOutlet UIButton *viewmyfavesbtn;

@property (strong,nonatomic) IBOutlet UIButton *musicbtn;

@property (strong,nonatomic) IBOutlet UILabel *musictext;


@end
