//
//  FrontPageSelectionViewController.h
//  petGallery
//
//  Created by mac on 7/26/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContentSelectPerformanceStatsViewController.h"

@class FrontPageSelectionViewController;


@protocol FrontPageSelectionViewControllerDelegate <NSObject>

- (void)FrontPageSelectionViewControllerBackToFrontPage:
(FrontPageSelectionViewController *)controller;
@end



@interface FrontPageSelectionViewController : UIViewController <UIScrollViewDelegate>
- (IBAction)backButtonPress:(id)sender;
@property (nonatomic,strong) IBOutlet UIScrollView *mainscrollview;

@property (nonatomic, weak) PFObject *selectedContent;
@property (nonatomic, strong) NSMutableArray *parseObjects;
@property (nonatomic, strong) NSNumber *parseobjindex;

@property (nonatomic, weak) id <FrontPageSelectionViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *accessToken;

@property (nonatomic, strong) NSString *fpsaccessmode;


@end
