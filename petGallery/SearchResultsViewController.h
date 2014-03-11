//
//  SearchResultsViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-28.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FrontPageSelectionViewController.h"
#import "TopBarViewController.h"
#include <stdlib.h>

@class SearchResultsViewController;

@protocol SearchResultsViewControllerDelegate <NSObject>

@required

- (void)dismissResults:(UIViewController *)dismissingvc;



@end


@interface SearchResultsViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate, FrontPageSelectionViewControllerDelegate>

{
    
    NSMutableArray *allImages;
    
    IBOutlet UIScrollView *photoScrollView;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
    
    }

- (IBAction)backbtnpress:(id)sender;

- (void)setUpImages:(NSArray *)images;
- (void)buttonTouched:(id)sender;


@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic, strong) id <SearchResultsViewControllerDelegate> srdelegate;
@property (strong,nonatomic) NSArray *parseobjs;
@property (strong,nonatomic) IBOutlet UIView *topbar;

@property (weak, nonatomic) IBOutlet UILabel *resultsNumLabel;

@end

