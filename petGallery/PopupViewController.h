//
//  PopupViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-28.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupViewController;

@protocol PopupViewControllerDelegate <NSObject>

@required
- (void)fullScreenButtonClick:(PopupViewController *) thiscontroller;


@end



@interface PopupViewController : UIViewController

@property (nonatomic, strong) id <PopupViewControllerDelegate> popdelegate;

@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

@property (nonatomic, strong) UIImage *imgforpopup;

-(IBAction) btnpress:id;



@end
