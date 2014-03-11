//
//  PetPhotoDetailViewController.h
//  petGallery
//
//  Created by mac on 6/24/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PetPhotoDetailViewController;
@protocol PetPhotoDetailViewControllerDelegate <NSObject>
- (void)PetPhotoDetailViewControllerDone:
(PetPhotoDetailViewController *)controller;

@end
@interface PetPhotoDetailViewController : UIViewController
{
  
    IBOutlet UIImageView *PetPhotoImage;
    UIImage *selectedImage;
    NSString *imageName;
}


@property (nonatomic, retain) IBOutlet UIImageView *PetPhotoImage;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, weak) id <PetPhotoDetailViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;


@end
