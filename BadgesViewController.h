//
//  BadgesViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-11.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>



@class BadgesViewController;

@protocol BadgesViewControllerDelegate

@required
-(void) dismissBVC:(BadgesViewController *) bvc;




@end




@interface BadgesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, weak) id <BadgesViewControllerDelegate> bvcdelegate;

@property (nonatomic,weak) IBOutlet UICollectionViewCell * badgecell;

@property (nonatomic,weak) IBOutlet UICollectionView * badgeview;

@property (nonatomic,strong) IBOutlet UISegmentedControl * badgepick;

@property (nonatomic,strong) IBOutlet UIView *mytopbar;


-(IBAction)badgetypechoice:(id)sender;

-(IBAction)backbtn:(id)sender;


@end
