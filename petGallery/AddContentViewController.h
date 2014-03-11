//
//  AddPetViewController.h
//  petGallery
//
//  Created by mac on 6/17/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "GlobeParticleEmitter.h"

@class AddContentViewController;

@protocol AddContentViewControllerDelegate

@required
- (void)Dismissacv:
(AddContentViewController *)controller;


@end



@interface AddContentViewController : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate>
{
MBProgressHUD *HUD;
}


@property (nonatomic, weak) id <AddContentViewControllerDelegate> acvdelegate;
@property (nonatomic, weak) id <UITextFieldDelegate> textdelegate;
@property (weak, nonatomic) IBOutlet UITextField *setCaption;
@property (weak, nonatomic) IBOutlet UITextField *setHashtags;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *addContentText;
@property (weak, nonatomic) IBOutlet UILabel *CaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *CategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *CameraLabel;
@property (weak, nonatomic) IBOutlet UILabel *LibraryLabel;
@property (weak, nonatomic) IBOutlet UIButton *addcontentButton;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak,nonatomic) IBOutlet UIView *topbar;


- (IBAction)contentAdd:(id)sender;
- (IBAction)setContentImage:(id)sender;
- (IBAction)doCameraForImage:(id) sender;

//- (void)uploadImage:(NSData *)imageData;

-(IBAction) backToMyStuff:(id)sender;


@end
