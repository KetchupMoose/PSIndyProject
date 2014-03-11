//
//  ContentSelectSocialViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-10.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <parse/parse.h>
//#import <Pinterest/Pinterest.h>
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import "PlayerData.h"
@interface ContentSelectSocialViewController : UIViewController <MBProgressHUDDelegate,MFMailComposeViewControllerDelegate>

- (IBAction)fbButton:(id)sender;

- (IBAction)twitterButton:(id)sender;

- (IBAction)pintButton:(id)sender;

- (IBAction)msgButton:(id)sender;
- (IBAction)faveButton:(id)sender;
//- (IBAction)redditButton:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *fbNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *pintNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *msgNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *favesLabel;

@property (weak, nonatomic) IBOutlet UILabel *getGoldLabel;

@property (weak, nonatomic) IBOutlet UIButton *faveBtn;
//@property (weak, nonatomic) IBOutlet UILabel *redditLabel;


//fbaccess token
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) PFObject *selectedparsepic;
@property (nonatomic,strong) UIImageView *theimage;

- (IBAction)openMail:(id)sender;

@end
