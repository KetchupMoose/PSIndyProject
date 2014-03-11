//
//  TuteSplashLoginViewController.h
//  Pick Something
//
//  Created by Macbook on 2014-01-09.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import <Parse/Parse.h>
#import "FrontSplashViewController.h"
#import "InternetOfflineViewController.h"
//#import "SMPageControl.h"

@interface TuteSplashLoginViewController : PFLogInViewController <UIPageViewControllerDataSource,UITextFieldDelegate,FrontSplashViewControllerDelegate,UIPageViewControllerDelegate,UIGestureRecognizerDelegate>


{
    UIPageViewController *pageController;
    UIPageControl *pageControl;
    NSArray *pageContent;
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *pageContent;

-(void) makestuffvisible;
-(void) makestuffnotvisible;
-(void) gotologin;

@end
