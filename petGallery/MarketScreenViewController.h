//
//  MarketScreenViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarViewController.h"
#import "MarketplaceQueryTableViewController.h"

@class MarketScreenViewController;

@protocol MarketScreenViewControllerDelegate

-(void) dismissMarketScreen:(MarketScreenViewController *)controller;

@end




@interface MarketScreenViewController : UIViewController <TopBarViewControllerDelegate,MarketplaceQueryTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *marketarea;
@property (weak, nonatomic) IBOutlet UIView *topbararea;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentControl;
- (IBAction)sortIndexChange:(id)sender;

@property (nonatomic, weak) id <MarketScreenViewControllerDelegate> mscreendelegate;

-(IBAction) backbtnpress;

@end
