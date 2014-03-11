//
//  HashtagSearchViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-28.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <parse/parse.h>
#import "SearchResultsviewController.h"
#import "TopbarViewController.h"
#import <QuartzCore/QuartzCore.h>

@class HashtagSearchViewController;

@protocol HashtagSearchViewControllerDelegate

@required
- (void) dismissSearchVC:(HashtagSearchViewController *) hsvc;


@end



@interface HashtagSearchViewController : UIViewController <SearchResultsViewControllerDelegate, UITextFieldDelegate>

@property (strong,nonatomic) NSString *selectedHashtag;

@property (strong,nonatomic) IBOutlet UITextField *hashtagSelectionBox;
@property (strong,nonatomic) IBOutlet UIButton *trendingButton;

@property (strong,nonatomic) IBOutlet UIView *topbar;

- (IBAction)backBtn:(id)sender;


- (IBAction)userEdited:(id)sender;

- (IBAction)trendingPress:(id)sender;

//set up delegate property and protocol
@property (nonatomic, strong) id <HashtagSearchViewControllerDelegate> hsvcDelegate;

@end
