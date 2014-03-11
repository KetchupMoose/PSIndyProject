//
//  PetLoginViewController.h
//  petGallery
//
//  Created by mac on 7/3/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <Parse/Parse.h>
#import "InternetOfflineViewController.h"
#import "UIView+Animation.h"
@interface PetLoginViewController : PFLogInViewController<UITextFieldDelegate,InternetOfflineViewControllerDelegate>


@end
