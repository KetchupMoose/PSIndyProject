//
//  PetRatingViewController.h
//  petGallery
//
//  Created by mac on 7/4/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface PetRatingViewController : UIViewController
@property (strong, nonatomic) IBOutlet PFImageView *PetRatingImageView;
- (IBAction)PetRatingSliderPick:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UILabel *PetRatingLabel;
- (IBAction)SendRatingButton:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *PetRatingSlider;

@end
