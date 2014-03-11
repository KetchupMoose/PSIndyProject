//
//  FrontSplashPageViewController.m
//  Pick Something
//
//  Created by Macbook on 2014-01-09.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import "FrontSplashPageViewController.h"

@interface FrontSplashPageViewController ()

@end

@implementation FrontSplashPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   
    //self.pageController.dataSource = self;
    //[[self.pageController view] setFrame:[[self view] bounds]];
    
    FrontSplashViewController *fsvc = [[FrontSplashViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObject:fsvc];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
