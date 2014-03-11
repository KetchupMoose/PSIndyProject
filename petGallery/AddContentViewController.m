//
//  ViewController.m
//  petGallery
//
//  Created by mac on 6/17/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "AddContentViewController.h"
#import "Pet.h"
#import <Parse/Parse.h>
#import "TopBarViewController.h"

@interface AddContentViewController ()


@end

@implementation AddContentViewController
@synthesize setCaption;
@synthesize setHashtags;
@synthesize imageButton;
@synthesize acvdelegate;
@synthesize CaptionLabel;
@synthesize CategoryLabel;
@synthesize CameraLabel;
@synthesize LibraryLabel;
@synthesize backButton;
@synthesize addContentText;
@synthesize contentImageView;
@synthesize topbar;
@synthesize textdelegate;
UIImage *chosenImage;
BOOL imgset;
NSInteger uploadcount = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.textdelegate = self;
    
    //method to add later to dismiss the keyboard when the user taps the screen
    /*
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    */
    TopBarViewController *tb;
    tb=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tb];
    
    [self.topbar addSubview:tb.view];
    
    tb.view.frame = self.topbar.bounds;
    
    self.topbar.backgroundColor = [UIColor clearColor];
    
    
    
    //set background
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"submitcontentbackground" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    UIImage *b = [self imageWithImage:bgimage scaledToSize:self.view.bounds.size];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:b];
    
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
         self.addContentText.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
         self.CaptionLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:8];
         self.CategoryLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:8];
     }
    else
    {
        self.addContentText.font = [UIFont fontWithName:@"CooperBlackStd" size:22];
        self.CaptionLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:14];
        self.CategoryLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:14];
        self.CameraLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:14];
        self.LibraryLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:14];
    }
   
    
    
    self.addContentText.backgroundColor = [UIColor clearColor];
    
    self.CaptionLabel.backgroundColor =[UIColor clearColor];
    
    self.CategoryLabel.backgroundColor = [UIColor clearColor];
    
    
    
   // [self setFirstProfileInfo];
    
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)setFirstProfileInfo {
    // check if the user has advanced profile stats, if not create them for the current user for the first time
    //move this function to the first nib the user sees after login for the future...
    
    //check if they have a row in the player stats table...
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query whereKey:@"user" equalTo:user];
    NSLog(@"Username: %@", user.objectId);
    
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"need to create a profile");
            //create first profile now
             PFUser *user = [PFUser currentUser];
            NSString *username = user.username;
            NSNumber *level = [NSNumber numberWithInt:1];
            NSNumber *currency = [NSNumber numberWithFloat:0];
            NSNumber *xp = [NSNumber numberWithFloat:0];
            
            PFObject *profileObject = [PFObject objectWithClassName:@"UserProfile"];
            [profileObject setObject:username forKey:@"Username"];
            [profileObject setObject:level forKey:@"Level"];
            [profileObject setObject:currency forKey:@"Currency"];
            [profileObject setObject:xp forKey:@"XP"];
            [profileObject setObject:user forKey:@"user"];
            
        [profileObject saveInBackground];
            
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            
            
        }    }];
    
    }

- (IBAction)contentAdd:(id)sender
{
   
    uploadcount = uploadcount+1;
    
    if(uploadcount>=10)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reached Create limit", nil) message:NSLocalizedString(@"Reached the create limit, come back later to add more cool stuff!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    
    //commenting outdated code for handling data in an object oriented fashion
    
    // Pet *newpet = [[Pet alloc] init];
    //newpet.petNamec = self.setCaption.text;
	 //newpet.petTypec = self.setHashtags.text;
       // newpet.petMarketThumbc = self.imageButton.currentImage;
   
    UIButton *btn = sender;
    
    CGRect myrect = btn.frame;
    CGPoint mypoint = CGPointMake(myrect.origin.x + (myrect.size.width / 2), myrect.origin.y + (myrect.size.height / 2));
    
    
    
    if(imgset==NO)
    {
       [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Set an Image", nil) message:NSLocalizedString(@"Set an Image before submitting!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
        
    }
    
    
    
    
    if(self.setCaption.text.length ==0)
        {
            
              [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add a Caption", nil) message:NSLocalizedString(@"Make sure you fill out a caption for the picture!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
            
            return;
            
        }
    if(self.setCaption.text.length >100)
    {
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Caption Too Long", nil) message:NSLocalizedString(@"100 Char Limit on Captions", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
        
        return;
        
    }
    
    if(self.setHashtags.text.length >100)
    {
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hashtags Too Long", nil) message:NSLocalizedString(@"100 Char Limit on Hashtags", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
        
        return;
        
    }
    
    
    if(self.setHashtags.text.length ==0)
    {
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add a Category", nil) message:NSLocalizedString(@"Add at least one category + extra gold if you add 3!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
        
        return;
        
    }
    
    GlobeParticleEmitter *gp = [[GlobeParticleEmitter alloc] initWithFrame:self.view.frame particlePosition:mypoint];
    [self.view addSubview:gp];
    
    [gp decayOverTime:2.0];

    
        void (^contentimguploadblock)(void);
        {
            UIImage *image = chosenImage;
            
            int maxw=320;
            int maxh=2000;
            CGSize myimgsize = image.size;
            
            CGSize *thesize = [self scalesize:&myimgsize maxWidth:maxw maxHeight:maxh];
            
            image = [self imageWithImage:image scaledToSize:*thesize];
            
            
            int maxwsmall = 145;
            int maxhsmall = 1000;
            
            CGSize *thesmallsize = [self scalesize:&myimgsize maxWidth:maxwsmall maxHeight:maxhsmall];
            
            UIImage *smallimage = [self imageWithImage:image scaledToSize:*thesmallsize];
            
            
                                   
            // Resize image
            //UIGraphicsBeginImageContext(CGSizeMake(640, 960));
            //[image drawInRect: CGRectMake(0, 0, 640, 960)];
            //UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
            //UIGraphicsEndImageContext();
            
            // Upload image
            //NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
            
                    
            // Save PFFile
            PFObject *imgObject;
            // set permissions for photoobject
            PFACL *contentPhotoACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [contentPhotoACL setPublicReadAccess:YES];
            [contentPhotoACL setPublicWriteAccess:YES];
            imgObject.ACL = contentPhotoACL;
            imgObject = [self uploadImage2:image withSmallImage:smallimage];
            
            // Add a relation between the petobject and photo
            
    }

    
}

- (int)magicNumber {
    
    return 42;
    
}

-(CGSize *)scalesize:(CGSize *)imgsize maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    
    CGFloat width = imgsize->width;
    
    CGFloat height = imgsize->height;
    
    if (width <= maxWidth && height <= maxHeight)
    {
        return imgsize;
    }
    
    
    CGSize newsize;
    
    
    if (width > maxWidth)
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            newsize.width = maxWidth;
            newsize.height = newsize.width / ratio;
        }
        else
        {
            newsize.width = maxWidth;
            newsize.height = newsize.width/ratio;
        }
    }
    
    if (newsize.height> maxHeight)
    {
        CGFloat maxratio = newsize.height/maxHeight;
        if (maxratio >1)
        {
            newsize.width = newsize.width/maxratio;
            newsize.height = maxHeight;
        }
        
    }
    
    //make sure to enforce a maximum height on upload so you dont get fkin nonsense.
    
    CGSize * size = &newsize;
    
    
    return size;
    
}
- (PFObject*)uploadImage2:(UIImage *)myimage withSmallImage:(UIImage *) smallimage
{
    
    NSData *imageData = UIImageJPEGRepresentation(myimage, 0.8f);
    NSData *smallimageData = UIImageJPEGRepresentation(smallimage, 0.8f);
    
          //check the image height
    
     NSLog(@"first height check image height: %ld", (long)myimage.size.height);
    NSLog(@"first width check image height: %ld", (long)myimage.size.width);
    //create nsnumber for float
    float imghfloat = myimage.size.height;
    float imgwfloat = myimage.size.width;
    
    NSNumber *imgheight = [NSNumber numberWithFloat:imghfloat];
    NSNumber *imgwidth = [NSNumber numberWithFloat:imgwfloat];
    
    
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    PFFile *smallImageFile = [PFFile fileWithName:@"smallImage.jpg" data:smallimageData];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Uploading";
    [HUD show:YES];
    
    // Create a PFObject around a PFFile and associate it with the current user
    PFObject *userPhoto = [PFObject objectWithClassName:@"funPhotoObject"];
    
    PFUser *user = [PFUser currentUser];
    [userPhoto setObject:user forKey:@"creator"];
    
    
    // Set the access control list to current user for security purposes
    PFACL *funPhotoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [funPhotoACL setPublicReadAccess:YES];
    [funPhotoACL setPublicWriteAccess:YES];
    
    userPhoto.ACL = funPhotoACL;
    
    //setting numbers for data upload on defaults for content.
    int defaultpriceint = 100;
    
    NSNumber *defaultPrice = [NSNumber numberWithInt:defaultpriceint];
    
    int defaultratingscore=0;
    NSNumber *dfltrating= [NSNumber numberWithInt:defaultratingscore];
    
    int nopicks = -1;
    NSNumber *nopicksnum = [NSNumber numberWithInt:nopicks];
    
    int defvalue = 10;
   
    NSNumber *defvalnum = [NSNumber numberWithInt:defvalue];
    
    NSNumber *defaultrank = [NSNumber numberWithInt:1];
    
    [userPhoto setObject:setCaption.text forKey:@"Caption"];
    [userPhoto setObject:setHashtags.text forKey:@"Hashtags"];
    [userPhoto setObject:defaultPrice forKey:@"Price"];
    [userPhoto setObject:dfltrating forKey:@"RatingScoreTotal"];
    [userPhoto setObject:@"forSale" forKey:@"status"];
    [userPhoto setObject:dfltrating forKey:@"avgRating"];
    [userPhoto setObject:dfltrating forKey:@"TotalRatings"];
    [userPhoto setObject:dfltrating forKey:@"TopWeekly"];
    [userPhoto setObject:dfltrating forKey:@"TotalLikes"];
    [userPhoto setObject:dfltrating forKey:@"pickPct"];
    [userPhoto setObject:nopicksnum forKey:@"totalPicks"];
    [userPhoto setObject:defvalnum forKey:@"contentValue"];
    [userPhoto setObject:defaultrank forKey:@"challengeRank"];
    
    
    [userPhoto setObject:imgheight forKey:@"imgHeight"];
    [userPhoto setObject:imgwidth forKey:@"imgWidth"];
    
    //take the separate commas and add them to separate hashtag objects
    // I should change this to cloud code eventually
    NSString *hashtext = setHashtags.text;
    NSArray *hashtagitems = [hashtext componentsSeparatedByString:@","];
    NSMutableArray *hashobjects = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *blah in hashtagitems)
    {
        //create or add to a hashtag object with that name
        //change this to do in cloud code.
        
        PFObject *hashtagObject = [PFObject objectWithClassName:@"funHashtag"];
        
        
        [hashtagObject setObject:blah forKey:@"hashtagstring"];
        [hashtagObject setObject:userPhoto forKey:@"funPhotoObject"];
        
        [hashobjects addObject:hashtagObject];
        i = i+1;
        
        
    }
    
    // Save hashtags
    if (i>0)
        
    {
        NSArray *hashobjs = [[NSArray alloc] initWithArray:hashobjects];
        
        [PFObject saveAllInBackground:hashobjs block:^(BOOL succeeded,NSError *error){
            if (error) {
                NSLog(@"Error saving: %@",error);
            } else if (!succeeded){
                NSLog(@"Saving operation failed with no error");
            } else{
                NSLog(@"hashtags saved");
            }
        }];;
    }
    
    
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Hide determinate HUD
            [HUD hide:YES];
            
            // Show checkmark
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            //HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            
          
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"image uploaded successfully");
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }
    
     ];
    
    [smallImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Hide determinate HUD
            [HUD hide:YES];
            
            
            
            // Show checkmark
            //HUD = [[MBProgressHUD alloc] initWithView:self.view];
            //[self.view addSubview:HUD];
            
            // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            //HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            //HUD.mode = MBProgressHUDModeCustomView;
            
            //HUD.delegate = self;
            
            
            [userPhoto setObject:smallImageFile forKey:@"smallimageFile"];
            
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"small image uploaded successfully");
                    
                    //give player gold
                    PlayerData *sharedData = [PlayerData sharedData];
                  
                    [sharedData addUserInfluenceOnCreate:10 withType:1];
                    
                    
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        //HUD.progress = (float)percentDone/100;
    }
     
     ];
    
    return userPhoto;
    
}

- (IBAction)setContentImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
   // picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = info[UIImagePickerControllerOriginalImage];
    
   [self.contentImageView setImage:chosenImage];
    //[self.imageButton setImage:chosenImage forState:UIControlStateHighlighted];
    //[self.imageButton setImage:chosenImage forState:UIControlStateSelected];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    imgset = YES;
    
    }
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        animatedDistance = 216-(460-moveUpValue-5);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doCameraForImage:(id) sender

    {
        // Check for camera
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
            // Create image picker controller
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            // Set source to the camera
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            
            // Delegate is self
            imagePicker.delegate = self;
            
            // Show image picker
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
           
        //device has no camera
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Camera", nil) message:NSLocalizedString(@"No Camera Detected!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
            return;
        
        }
            
}



-(IBAction) backToMyStuff:(id)sender
{
    [self.acvdelegate Dismissacv:self];
    
}

- (void)viewDidLayoutSubviews
{

    UIButton *backbtn = self.backButton;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            //leave as normal
            //[submnewtext setFrame:CGRectMake(35,0, 200, 25)];
            
            //[mysubmisstext setFrame:CGRectMake(39,250, 200, 50)];
            //[ myfavetext setFrame:CGRectMake(45,325, 200, 50)];
        }
        if(result.height == 568)
        {
            // iPhone 5
            //give stage extra dimensions
            NSLog(@"iphone 5s settings createpage");
            
            CGRect btnframe = backbtn.frame;
            btnframe.origin.y = btnframe.origin.y+10;
            backbtn.frame = btnframe;
            
            CGRect label2frame = self.addContentText.frame;
            label2frame.origin.y=label2frame.origin.y+10;
            self.addContentText.frame = label2frame;
            
        }
    }
}



@end
