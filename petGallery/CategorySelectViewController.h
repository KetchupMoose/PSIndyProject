//
//  CategorySelectViewController.h
//  Pick Something
//
//  Created by Macbook on 2014-01-31.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarViewController.h"
#import <Parse/Parse.h>


@class CategorySelectViewController;

@protocol CategorySelectViewControllerDelegate <NSObject>

@required
- (void)CategoryPick:(CategorySelectViewController *) thiscontroller;
- (void)setParentChallenges:(NSArray *) challenges;



@end



@interface CategorySelectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton  *catbutton1;
@property (weak, nonatomic) IBOutlet UIButton  *catbutton2;
@property (weak, nonatomic) IBOutlet UIButton  *catbutton3;
@property (weak, nonatomic) IBOutlet UIButton  *catbutton4;

- (IBAction)cat1press:(id)sender;
- (IBAction)cat2press:(id)sender;
- (IBAction)cat3press:(id)sender;
- (IBAction)cat4press:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak,nonatomic) IBOutlet UIImageView *bgImage;

@property (weak,nonatomic) id <CategorySelectViewControllerDelegate> csdelegate;


@end
