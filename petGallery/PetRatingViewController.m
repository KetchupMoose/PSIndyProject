//
//  PetRatingViewController.m
//  petGallery
//
//  Created by mac on 7/4/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PetRatingViewController.h"
#import <Parse/Parse.h>
@interface PetRatingViewController ()

@end

@implementation PetRatingViewController
{
    PFObject *queryresult;
    NSNumber *rateslidervalue;
}
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
    
    //setup the slider
    self.PetRatingSlider.minimumValue= 0;
    self.PetRatingSlider.maximumValue=100;
    
    //setup the image of object to be rated
    
    //query for a suitable rating object
    //[self getImageToRate];
    
    //load object into imageview
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)getImageToRate {
    // need to add hud code here so it shows its loading the image..
    PFUser *user = [PFUser currentUser];
    
    PFQuery *ratingsQuery = [PFQuery queryWithClassName:@"funPhotoRating"];
    
    [ratingsQuery whereKey:@"Rater" equalTo:user];
    [ratingsQuery includeKey:@"funPhotoObject"];
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
    
    //later change this to be not equal to and boolean flagged for sale.
    [query whereKey:@"creator" notEqualTo:user];
    [query whereKey:@"owner" notEqualTo:user];

    
    //gets only photos where the user is not the creator, owner, and they have not previously rated
    
    //this isn't working now for some reason...
    //found the answer here.
   // https://www.parse.com/questions/trouble-with-nested-query-using-objectid
    [query whereKey:@"objectId" doesNotMatchKey:@"funPhotoObjectString" inQuery:ratingsQuery];
    
    
    [query orderByDescending:@"createdAt"];
    
    int querylimit = 1;
    
    NSInteger *querylimitnum = &querylimit;
    
    query.limit = *querylimitnum ;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            
            //setup a pet object to add and set its properties from parse object
            
            
            for (PFObject *petphotodata in objects)
            {
                
                PFFile *theImage = [petphotodata objectForKey:@"imageFile"];
                NSLog(@"retrieved this image to rate: %@", theImage.name);
                self.PetRatingImageView.file =theImage;
                queryresult=petphotodata;
               [self.PetRatingImageView loadInBackground];
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    //need method to call to reload table
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
      [self getImageToRate];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PetRatingSliderPick:(UISlider *)sender {
    float sliderValue = [sender value];
    NSInteger sliderIntValue= roundf(sliderValue);
    NSString *ratevalue = [NSString stringWithFormat:@"%i", sliderIntValue];
    self.PetRatingLabel.text = ratevalue;
    
    //set class variable to rating

    rateslidervalue=[NSNumber numberWithInteger:sliderIntValue];
}
- (IBAction)SendRatingButton:(id)sender {
    
    NSString *selectedObject = queryresult.objectId;
    
    //fix this later for the warning
  NSLog(@"This is the fun photo object: %@", selectedObject);

    
    //add user rating
    PFUser *user = [PFUser currentUser];
    
    
    PFObject *userRating = [PFObject objectWithClassName:@"funPhotoRating"];
    [userRating setObject:user forKey:@"Rater"];
    [userRating setObject:queryresult forKey:@"funPhotoObject"];
    [userRating setObject:queryresult.objectId forKey:@"funPhotoObjectString"];
  
    
   
    [userRating setObject:rateslidervalue forKey:@"ratingValue"];
    
    
    
    [userRating saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The gameScore saved successfully.
            NSLog(@"This got saved on User Rating: %@", queryresult.objectId);
            
            //get the next image to rate
            [self getImageToRate];
            
            //future:add some sort of progress hub here
        } else {
            // There was an error saving the gameScore.
            NSLog(@"Error: %@", error);
        }
    }];
    
    
    //[queryresult addObject:userRating forKey:@"ratingsArray"];
   // [queryresult saveInBackground];
    
    

    
}
@end
