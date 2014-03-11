//
//  ContentSelectCaptionViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-10.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "ContentSelectCaptionViewController.h"

@interface ContentSelectCaptionViewController ()


@end

@implementation ContentSelectCaptionViewController

@synthesize captionLabel;

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
    
          if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
          {
             captionLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:12];
          }
    else
    {
        captionLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:18];
        //captionLabel.numberOfLines = 3;
        
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
