//
//  MyPetDetailsViewController.m
//  petGallery
//
//  Created by mac on 7/9/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "MyPetDetailsViewController.h"

@interface MyPetDetailsViewController ()

@end

@implementation MyPetDetailsViewController

@synthesize delegate;
@synthesize selectedPet;
@synthesize PriceTextField;


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
    
    PFObject *petdataobj = [selectedPet objectForKey:@"petObject"];
    self.PetNameLabel.text = [petdataobj objectForKey:@"Name"];
    
    self.PetDetailsImageView.file= [selectedPet objectForKey:@"imageFile"];
    

    
    
    
    //replace with something cool to see ratings in detail...
    //[self queryforAverageRating];
    
    
    [self.PetDetailsImageView loadInBackground];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)PetSaleButton:(id)sender {
    
    //add commands to buy the pet and change backend database via parse
    PFUser *user = [PFUser currentUser];
    
    //give this user permission to change info
    
    [selectedPet setObject:@"forSale" forKey:@"status"];
    
    NSString *petPrice = self.PriceTextField.text;
    
    NSInteger *petPriceint = [petPrice intValue];
    
    NSNumber *petpricenum = [NSNumber numberWithInt:*petPriceint];
    
   
    [selectedPet setObject:petpricenum forKey:@"Price"];
    
    
    [selectedPet save];
    
    
    
}
- (IBAction)BackToMyPetsButton:(id)sender {
    //send user back to marketplace
    [self.delegate MyPetDetailsViewControllerBackToMyPets:self];
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == PriceTextField) {
        
        // .....
        NSLog(@"text field edited");

        
       return YES;
        
    }
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)PriceTextField {
    
    
    
    [self.PriceTextField resignFirstResponder];
    
    
    
    return YES;
}

 - (BOOL)disablesAutomaticKeyboardDismissal {
     return NO;
 }
@end
