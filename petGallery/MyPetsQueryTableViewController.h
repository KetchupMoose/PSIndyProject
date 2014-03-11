//
//  MyPetsQueryTableViewController.h
//  petGallery
//
//  Created by mac on 7/9/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <Parse/Parse.h>
#import "MyPetDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PlayerData.h"
#import "UIView+Animation.h"
#import "MyPetCollectUIButton.h"
#import "FrontPageSelectionViewController.h"
#import "MyPetsQueryUITableViewCell.h"
#import <MessageUI/MessageUI.h>
@class MyPetsQueryTableViewController;

@protocol MyPetsQueryTableViewControllerDelegate

@optional

-(void) ValueChange;


@end




@interface MyPetsQueryTableViewController : PFQueryTableViewController <MyPetDetailsViewControllerDelegate,FrontPageSelectionViewControllerDelegate,MFMailComposeViewControllerDelegate>


@property (strong,nonatomic) NSString *displayMode;

@property (nonatomic, weak) id <MyPetsQueryTableViewControllerDelegate> mypqtdelegate;


@end
