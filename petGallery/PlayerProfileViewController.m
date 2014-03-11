//
//  PlayerProfileViewController.m
//  petGallery
//
//  Created by mac on 7/9/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PlayerProfileViewController.h"
#import <Parse/Parse.h>
@interface PlayerProfileViewController ()

@end

@implementation PlayerProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getProfileInfo];
    
    
}

- (void)getProfileInfo {
    // load the current user's profile from a query
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query whereKey:@"user" equalTo:user];
     NSLog(@"Username: %@", user.objectId);
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            
            //setup a pet object to add and set its properties from parse object
            
            
            for (PFObject *userdata in objects)
            {
                self.profileUsername.text = [userdata objectForKey:@"Username"];
                NSNumber *goldnumber = [userdata objectForKey:@"Currency"];
                NSString *GoldString = [NSString stringWithFormat:@"%@", goldnumber];
                
                self.profileGoldLabel.text = GoldString;
                
                
                NSNumber *levelnumber = [userdata objectForKey:@"Level"];
                NSString *LevelString = [NSString stringWithFormat:@"%@", levelnumber];
                
                  self.profileLevelLabel.text = LevelString;
                
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
    
    
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

@end
