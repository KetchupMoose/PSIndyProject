//
//  PetPhotoViewController.h
//  petGallery
//
//  Created by mac on 6/19/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "PetPhotoDetailViewController.h"
#include <stdlib.h>
@interface PetPhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate, PetPhotoDetailViewControllerDelegate>
{
   
    NSMutableArray *allImages;
    
    IBOutlet UIScrollView *photoScrollView;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}

- (IBAction)refresh:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;
- (void)buttonTouched:(id)sender;

@property (strong, nonatomic) UIViewController *viewController;


@end
