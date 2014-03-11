//
//  TopBarWithBackButtonViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopBarWithBackButtonViewController;

@protocol TopBarWithBackButtonViewControllerDelegate

- (void)backbtnpress:(TopBarWithBackButtonViewController *) tbb;



@end



@interface TopBarWithBackButtonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *levelbutton;
- (IBAction)levelbuttonclick:(id)sender;
- (IBAction)backbuttonclick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *xpbarbutton;

@property (weak, nonatomic) IBOutlet UIButton *goldbutton;

@property (nonatomic, weak) id <TopBarWithBackButtonViewControllerDelegate> tbwbbdelegate;



@end
