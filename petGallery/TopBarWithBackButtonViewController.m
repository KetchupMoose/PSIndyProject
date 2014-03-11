//
//  TopBarWithBackButtonViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "TopBarWithBackButtonViewController.h"
#import <parse/parse.h>

@interface TopBarWithBackButtonViewController ()

@end

@implementation TopBarWithBackButtonViewController

@synthesize xpbarbutton;
@synthesize goldbutton;
@synthesize levelbutton;
@synthesize tbwbbdelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    
	// Do any additional setup after loading the view.
    
    //query and get some sexy player data!
    
    [self getProfileInfo];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getProfileInfo {
    // load the current user's profile from a query
    PFUser *user = [PFUser currentUser];
    
    NSString *xpString = [[user objectForKey:@"exp"] stringValue];
    NSString *lvlString = [[user objectForKey:@"level"] stringValue];
    NSString *goldString = [[user objectForKey:@"Currency"] stringValue];
    
    
    
    [self.xpbarbutton setTitle:xpString forState:UIControlStateNormal];
    [self.levelbutton setTitle:lvlString forState:UIControlStateNormal];
    [self.goldbutton setTitle:goldString forState:UIControlStateNormal];
    
}


- (IBAction)levelbuttonclick:(id)sender {
}

- (IBAction)backbuttonclick:(id)sender
{
   
    NSLog(@"back button pressed");
    
    [self.tbwbbdelegate backbtnpress:self];
    
}


@end
