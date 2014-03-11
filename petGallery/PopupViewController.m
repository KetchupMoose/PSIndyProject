//
//  PopupViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-28.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PopupViewController.h"

@interface PopupViewController ()

@end

@implementation PopupViewController
@synthesize popdelegate;
@synthesize imgforpopup;

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
    
    [self.fullScreenBtn setImage:imgforpopup forState:UIControlStateNormal];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) btnpress:id
{
    // do the delegate function.
    [self.popdelegate fullScreenButtonClick:self];
    
    
}

@end
