//
//  MyPetDetailsViewController.h
//  petGallery
//
//  Created by mac on 7/9/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@class MyPetDetailsViewController;
@protocol MyPetDetailsViewControllerDelegate <NSObject>
- (void)MyPetDetailsViewControllerBackToMyPets:
(MyPetDetailsViewController *)controller;

- (void)MyPetDetailsViewControllerSellPet:
(MyPetDetailsViewController *)controller
                          SellPet:(PFObject *)SellPet;


@end




@interface MyPetDetailsViewController : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) id <MyPetDetailsViewControllerDelegate> delegate;
- (IBAction)PetSaleButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *BackToMyPetsButton;

@property (strong, nonatomic) IBOutlet UITextField *PriceTextField;

@property (strong, nonatomic) IBOutlet PFImageView *PetDetailsImageView;

@property (strong, nonatomic) IBOutlet UILabel *PetNameLabel;

@property (nonatomic, weak) PFObject *selectedPet;

- (IBAction)BackToMyPetsButton:(id)sender;

@end
