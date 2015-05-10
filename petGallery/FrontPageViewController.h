//
//  FrontPageViewController.h
//  petGallery
//
//  Created by mac on 7/25/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontPagePFQueryTableViewController.h"
#import "TwoTableCollectionView.h"
#import "PSCollectionView.h"
#import "FrontPageSelectionViewcontroller.h"
#import "UIView+Animation.h"
#import "HashtagSearchViewController.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD.h"


//brian.  I think I have to do something like set the query property of the data table as an accessible property and then re-set it from outside of the class.  The goal is to have the table change its results depending on the navigation selection

@interface FrontPageViewController : UIViewController <UIScrollViewDelegate,PSCollectionViewDelegate,PSCollectionViewDataSource,FrontPageSelectionViewControllerDelegate,HashtagSearchViewControllerDelegate,SDWebImageManagerDelegate,MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *FrontNavigationBar;
- (IBAction)FrontNavigationBarChange:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *stage;
@property (weak, nonatomic) IBOutlet UIButton *browsebtn;
@property (weak, nonatomic) IBOutlet UIView *topbarcontainer;

-(IBAction) browsebtn:id;


@property (strong,nonatomic) NSMutableArray *contentObjectsArray;

@property (strong,nonatomic) PSCollectionView *tbtvc;


@end
