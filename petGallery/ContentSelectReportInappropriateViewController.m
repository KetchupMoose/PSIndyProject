//
//  ContentSelectReportInappropriateViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-30.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "ContentSelectReportInappropriateViewController.h"

@interface ContentSelectReportInappropriateViewController ()

@end

@implementation ContentSelectReportInappropriateViewController

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
          self.reportLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:12];
          
          self.reportLabel2.font =  [UIFont fontWithName:@"CooperBlackStd" size:9];
      }
    else
    {
        self.reportLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:16];
        
        self.reportLabel2.font =  [UIFont fontWithName:@"CooperBlackStd" size:11];
    }
  
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reportContent:(id)sender
{
    //send object report and do mb progress hud
    NSString *selectedObject = self.selectedcontentobj.objectId;
    
    //fix this later for the warning
    NSLog(@"This is the fun photo object: %@", selectedObject);
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Reporting Content";
    [HUD show:YES];
    
    HUD.progress = (float)25/100;
    
    
    
    //add user rating
    PFUser *user = [PFUser currentUser];
    
    
    PFObject *userProblem = [PFObject objectWithClassName:@"funPhotoProblem"];
    [userProblem setObject:user forKey:@"Reporter"];
    [userProblem setObject:self.selectedcontentobj forKey:@"funPhotoObject"];
    [userProblem setObject:self.selectedcontentobj.objectId forKey:@"funPhotoObjectString"];
    [userProblem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [HUD hide:YES];
           
            //show a UI Alert confirming.
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Content Reported", nil) message:NSLocalizedString(@"Thank you, our team will investigate the content and take appropriate action.  We take these reports very seriously and appreciate your help.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
            //future:add some sort of progress hub here
        } else {
            // There was an error saving the gameScore.
            NSLog(@"Error: %@", error);
        }
    }];

}

@end
