//
//  BuyPetViewController.m
//  petGallery
//
//  Created by mac on 7/3/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "BuyPetViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "InternetOfflineViewController.h"

//need to implement delegate here
@interface BuyPetViewController ()

@end

@implementation BuyPetViewController


@synthesize delegate;
@synthesize selectedPet;
@synthesize averageRating;
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
    PFObject *petdataobj = selectedPet;
    self.CaptionLabel.text = [petdataobj objectForKey:@"Caption"];
    //self.BuyPetTypeLabel.text = [petdataobj objectForKey:@"Type"];
    
    self.BuyContentImage.file= [selectedPet objectForKey:@"imageFile"];
    
    
    //self.BuyPetRatingLabel.text = selectedPet.objectId;
        
  [self queryforAverageRating];
    
    
    [self.BuyContentImage loadInBackground];
}

- (void)queryforAverageRating
{
    
    PFObject *petdataobj = selectedPet;
    
    NSString *petphotoobjectname = petdataobj.objectId;
    NSLog(@"the objectid was:%@", petphotoobjectname);
   
    [PFCloud callFunctionInBackground:@"averageStars"
                       withParameters:@{@"funPhotoObj": petphotoobjectname}
                                block:^(NSNumber *ratings, NSError *error) {
                                    if (!error) {
                                        // ratings is 4.5
                                        
                                            NSString *myString = [ratings stringValue];
                                            self.BuyContentRatingLabel.text = myString;
                                        
                                    }
                                    else
                                    {
                                    self.BuyContentRatingLabel.Text = @"No Ratings Yet";
                                    }
                                }];
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)BuyContentButton:(id)sender {
    
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==NO)
    {
        InternetOfflineViewController *iovc = [[InternetOfflineViewController alloc] init];
        
        [self addChildViewController:iovc];
        
        [self.view addSubview:iovc.view];
    }
    
    
    
    //add commands to buy the pet and change backend database via parse
    PFUser *user = [PFUser currentUser];
    NSString *useridstring = user.objectId;
    PFObject *petdataobj = selectedPet;
    NSString *idstring = petdataobj.objectId;
    
    //cloud function to test if the user can buy
    [PFCloud callFunctionInBackground:@"buyObjectFromCreatorForInfluence"
                       withParameters:@{@"user":useridstring,@"objID":idstring}
                                block:^(NSString *success, NSError *error) {
                                    if (!error) {
                                        // ratings is 4.5
                                        NSString *myString = success;
                                        self.BuyContentRatingLabel.text = myString;
                                    }
                                }];
    
}

- (IBAction)BackToMarketNavigate:(id)sender {
    
    //send user back to marketplace
    [self.delegate BuyPetViewControllerBackToMarketplace:self];
    
}
@end
