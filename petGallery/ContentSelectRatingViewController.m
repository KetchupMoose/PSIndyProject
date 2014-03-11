//
//  ContentSelectRatingViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-10.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "ContentSelectRatingViewController.h"

@interface ContentSelectRatingViewController ()

@end

@implementation ContentSelectRatingViewController
{
    NSNumber *rateslidervalue;
}
@synthesize selectedContent;
@synthesize ratingSlider;
@synthesize ratingImgView;
@synthesize ratingHeaderLabel;
BOOL ratedcheck;

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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.ratingHeaderLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
    }
    else
    {
        self.ratingHeaderLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //setup the slider
    self.ratingSlider.minimumValue= 0;
    self.ratingSlider.maximumValue=100;
    
    self.ratingSlider.value = 50;
    rateslidervalue = [NSNumber numberWithInt:50];
    
    self.ratingSendBtn.userInteractionEnabled=false;
    
    
  
    
    //if the person already rated, don't show the rate button but show already rated instead.
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoRating"];
    [query whereKey:@"Rater" equalTo:user];
    [query whereKey:@"funPhotoObject" equalTo:self.selectedContent];
    
   [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error)
        {
            self.ratingSendBtn.userInteractionEnabled=TRUE;
            if(object==nil)
            {
                //set no user ratings
               
                UILabel *ratebtnlabel = [[UILabel alloc] initWithFrame:self.ratingSendBtn.bounds];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    ratebtnlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
                }
                else
                {
                    ratebtnlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
                }
                
                
                ratebtnlabel.text = @"Rate";
                
                ratebtnlabel.textAlignment = NSTextAlignmentCenter;
                
                ratebtnlabel.textColor = [UIColor whiteColor];
                
                ratebtnlabel.backgroundColor = [UIColor clearColor];
                
              
                
            }
            else
            {
                //set user rated
                
                UILabel *alreadyRatedLabel =[[UILabel alloc] initWithFrame:self.ratingSendBtn.frame];
                
                alreadyRatedLabel.text = @"Already Rated";
                alreadyRatedLabel.numberOfLines = 2;
                alreadyRatedLabel.backgroundColor = [UIColor clearColor];
                
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    alreadyRatedLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
                }
                else
                {
                    alreadyRatedLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:18];
                }
                
                alreadyRatedLabel.textAlignment = NSTextAlignmentCenter;
                
                self.ratingSendBtn.alpha = 0;
                
                [self.view addSubview:alreadyRatedLabel];
                
                self.ratingSlider.value = [[self.selectedContent objectForKey:@"avgRating"] floatValue];
                
               // float ratevalue =[[self.selectedContent objectForKey:@"avgRating"] floatValue];
                NSString *fileName = [[NSBundle mainBundle] pathForResource:@"64_checkmark" ofType:@"png"];
                UIImage *chkimage = [UIImage imageWithContentsOfFile:fileName];
                
                CGSize chkimgsize = chkimage.size;
                
                
                CGSize newsize = CGSizeMake(chkimgsize.width/3,chkimgsize.height/3);
                
                UIImage *resizedchkimage = [self imageWithImage:chkimage scaledToSize:newsize];
                
                
                [self.ratingSlider setThumbImage:resizedchkimage forState:UIControlStateNormal];
                
                
                
                self.ratingImgView.image = [self getRatingImage:[NSNumber numberWithFloat:self.ratingSlider.value]];
            }
        }
       
            self.ratingSendBtn.userInteractionEnabled=TRUE;
      
           //set no user ratings
           
           UILabel *ratebtnlabel = [[UILabel alloc] initWithFrame:self.ratingSendBtn.bounds];
           if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
           {
               ratebtnlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
           }
           else
           {
               ratebtnlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
           }
           
           
           ratebtnlabel.text = @"Rate";
           
           ratebtnlabel.textAlignment = NSTextAlignmentCenter;
           
           ratebtnlabel.textColor = [UIColor whiteColor];
           
           ratebtnlabel.backgroundColor = [UIColor clearColor];
        
   }];
  
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

/*
-(BOOL) UserAlreadyRated
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoRating"];
    [query whereKey:@"Rater" equalTo:user];
    [query whereKey:@"funPhotoObject" equalTo:self.selectedContent];
    
   PFObject *qresult = [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
       if (!error)
       {
           if(object==nil)
           {
               //set no user ratings
           }
           else
           {
               //set user rated
           }
       }
   
   }
    
                        return NO;
                        
       
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ratingbuttonpress:(id)sender {
    NSString *selectedObject = selectedContent.objectId;
    
    //fix this later for the warning
    NSLog(@"This is the fun photo object: %@", selectedObject);
    
   MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Adding Rating";
    [HUD show:YES];
    
    HUD.progress = (float)25/100;
    
    
    
    //add user rating
    PFUser *user = [PFUser currentUser];
    
    
    PFObject *userRating = [PFObject objectWithClassName:@"funPhotoRating"];
    [userRating setObject:user forKey:@"Rater"];
    [userRating setObject:selectedContent forKey:@"funPhotoObject"];
    [userRating setObject:selectedContent.objectId forKey:@"funPhotoObjectString"];
    
    [userRating setObject:rateslidervalue forKey:@"ratingValue"];
    
    
    
    [userRating saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [HUD hide:YES];
            
            // The gameScore saved successfully.
            NSLog(@"This got saved on User Rating: %@", selectedContent.objectId);
            
            //do some code to get the current average rating and give the user some gold + xp for submitting their rating
            float totalrates = [[self.selectedContent objectForKey:@"TotalRatings"] floatValue];
            
            float prevavg =[[self.selectedContent objectForKey:@"avgRating"] floatValue];
            
            if(totalrates==0)
            {
                //first rating!
                
                //give user 25 gold, 0 xp, 0 influence
                
                PlayerData *sharedData = [PlayerData sharedData];
                
               float prog=  [sharedData AddGoldXPScoreVote:25 withXP:0 withScore:0];
                
                //transform slider to that rating
                [self setSliderPicked:self.ratingSlider.value];
                
                
                //popup text saying first rating
                [self popupFirstRatingText];
            }
            else
            {
                float newavg;
                newavg = ((prevavg *totalrates) +ratingSlider.value) /(totalrates+1);
                
                
                //if new avg is close to the player's rating, give them a reward.
                
                if(abs(newavg-prevavg) <=10)
                {
                    //good rating!
                    PlayerData *sharedData = [PlayerData sharedData];
                    
                    float prog=  [sharedData AddGoldXPScoreVote:10 withXP:0 withScore:0];
                    
                    [self popupGoodRatingText];
                    
                    
                }
                
                [self setSliderPicked:newavg];
                
                
            }
            
            
            //future:add some sort of progress hub here
        } else {
            // There was an error saving the gameScore.
            NSLog(@"Error: %@", error);
        }
    }];

    
    
}

-(void) popupGoodRatingText
{
    //present the win or loss text with a quick pop-out
    UILabel *feedbacktext = [[UILabel alloc] init];
    feedbacktext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
    feedbacktext.numberOfLines = 2;
    feedbacktext.text = @"Close to Average! +10 Gold";
    
    feedbacktext.shadowColor = [UIColor blackColor];
    feedbacktext.backgroundColor = [UIColor clearColor];
    feedbacktext.frame = CGRectMake(0,30,320, 40);
    feedbacktext.textColor = [UIColor yellowColor];
    feedbacktext.textAlignment = NSTextAlignmentCenter;
      [self animatetextsizeincrease:feedbacktext];
}



-(void) popupFirstRatingText
{
    //present the win or loss text with a quick pop-out
    UILabel *feedbacktext = [[UILabel alloc] init];
    feedbacktext.font = [UIFont fontWithName:@"CooperBlackStd" size:15];
    feedbacktext.numberOfLines = 2;
    feedbacktext.text = @"First Rating!  +25 Gold";
    
    feedbacktext.shadowColor = [UIColor blackColor];
    feedbacktext.backgroundColor = [UIColor clearColor];
    feedbacktext.frame = CGRectMake(0,30,320, 40);
    feedbacktext.textColor = [UIColor yellowColor];
    feedbacktext.textAlignment = NSTextAlignmentCenter;
    
    [self animatetextsizeincrease:feedbacktext];
    
}

-(void) animatetextsizeincrease:(UILabel *) mylabel
{
    [self.view addSubview:mylabel];
    //[UIView beginAnimations:nil context:nil/*contextPoint*/];
    //mylabel.transform = CGAffineTransformMakeScale(2, 2); //increase the size by 2
    //etc etc same procedure for the other labels.
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDelay:0.2];
    //[UIView setAnimationDuration:0.5];
    //[UIView setAnimationRepeatCount:4];
    //[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //[UIView commitAnimations];
    mylabel.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    [UIView animateWithDuration:0.5f
                          delay:0.2f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         mylabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     }
                     completion:^(BOOL finished) {
                         [self animateMoveAndAlphaOff:mylabel];
                     }];
    
}

-(void) animateMoveAndAlphaOff:(UILabel *) mylabel
{
    [UIView animateWithDuration:0.7f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         mylabel.frame = CGRectMake(mylabel.frame.origin.x, mylabel.frame.origin.y-20,mylabel.frame.size.width,mylabel.frame.size.height);
                         mylabel.alpha = 0.1;
                         
                     }
                     completion:^(BOOL finished) {
                         [mylabel removeFromSuperview];
                     }];
}



-(void) setSliderPicked:(float)rating
{
    UILabel *alreadyRatedLabel =[[UILabel alloc] initWithFrame:self.ratingSendBtn.frame];
    
    alreadyRatedLabel.text = @"Already Rated";
    alreadyRatedLabel.numberOfLines = 2;
    alreadyRatedLabel.backgroundColor = [UIColor clearColor];
    //46 49 146 navy blue for browse title
    UIColor *mytbcolor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:146/255.0 alpha:1];
    alreadyRatedLabel.textColor = mytbcolor;
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
       {
           alreadyRatedLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
       }
    else
    {
         alreadyRatedLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:18];
    }
   
    
    alreadyRatedLabel.textAlignment = NSTextAlignmentCenter;
    
    self.ratingSendBtn.alpha = 0;
    
    [self.view addSubview:alreadyRatedLabel];
    
    self.ratingSlider.value = rating;
    
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"64_checkmark" ofType:@"png"];
    UIImage *chkimage = [UIImage imageWithContentsOfFile:fileName];
    
    CGSize chkimgsize = chkimage.size;
    
    
    CGSize newsize = CGSizeMake(chkimgsize.width/3,chkimgsize.height/3);
    
    UIImage *resizedchkimage = [self imageWithImage:chkimage scaledToSize:newsize];
    
    
    [self.ratingSlider setThumbImage:resizedchkimage forState:UIControlStateNormal];
    
    self.ratingSlider.enabled = NO;
    
    self.ratingImgView.image = [self getRatingImage:[NSNumber numberWithFloat:self.ratingSlider.value]];
    
    
}



- (IBAction)ratingSliderPick:(UISlider *)sender  {
    
    float sliderValue = [sender value];
    
    NSInteger sliderIntValue= roundf(sliderValue);
    NSString *ratevalue = [NSString stringWithFormat:@"%i", sliderIntValue];
    
    //set class variable to rating
    
    rateslidervalue=[NSNumber numberWithInteger:sliderIntValue];
    
    UIImage *smileyimage = [self getRatingImage:rateslidervalue];
    
    self.ratingImgView.image=smileyimage;
    
    
}

-(UIImage *)getRatingImage:(NSNumber *) slidervalue {
    
    int ratingvalue = [slidervalue integerValue];
    
    NSString * imgtoreturn;
    //imgnamedfixhere
    
    
    //UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    if (ratingvalue <6)
    {
      imgtoreturn = [[NSBundle mainBundle] pathForResource:@"1to5" ofType:@"png"];
        
    }
    if (ratingvalue >=6 && ratingvalue <11)
    {
        //imgtoreturn = [UIImage imageNamed:@"6to10.png"];
        imgtoreturn = [[NSBundle mainBundle] pathForResource:@"6to10" ofType:@"png"];
    }
    if (ratingvalue >=11 && ratingvalue <21)
    {
        //imgtoreturn = [UIImage imageNamed:@"11to20.png"];
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"11to20" ofType:@"png"];
        
    }
    if (ratingvalue >=21 && ratingvalue <31)
    {
    //imgtoreturn = [UIImage imageNamed:@"21to30.png"];
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"21to30" ofType:@"png"];
    }
    if (ratingvalue >=31 && ratingvalue <41)
    {
     //imgtoreturn = [UIImage imageNamed:@"31to40.png"];
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"31to40" ofType:@"png"];
    }
    if (ratingvalue >=41 && ratingvalue <51)
    {
        //imgtoreturn = [UIImage imageNamed:@"41to50.png"];
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"41to50" ofType:@"png"];
    }
    if (ratingvalue >=51 && ratingvalue <61)
    {
        //imgtoreturn = [UIImage imageNamed:@"51to60.png"];
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"51to60" ofType:@"png"];
    }
    if (ratingvalue >=61 && ratingvalue <71)
    {
        //imgtoreturn = [UIImage imageNamed:@"61to70.png"];
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"61to70" ofType:@"png"];
    }
    if (ratingvalue >=71 && ratingvalue <81)
    {
        //imgtoreturn = [UIImage imageNamed:@"71to80.png"];
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"71to80" ofType:@"png"];
    }
    if (ratingvalue >=81 && ratingvalue <86)
    {
       // imgtoreturn = [UIImage imageNamed:@"81to85.png"];
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"81to85" ofType:@"png"];
    }
    if (ratingvalue >=86 && ratingvalue <91)
    {
         imgtoreturn = [[NSBundle mainBundle] pathForResource:@"86to90" ofType:@"png"];
    }
    if (ratingvalue >=91 && ratingvalue <96)
    {
        //imgtoreturn = [UIImage imageNamed:@"91to95.png"];
        imgtoreturn = [[NSBundle mainBundle] pathForResource:@"91to95" ofType:@"png"];
    }
    if (ratingvalue >=96)
    {
        //imgtoreturn = [UIImage imageNamed:@"96to100.png"];
        imgtoreturn = [[NSBundle mainBundle] pathForResource:@"96to100" ofType:@"png"];
    }
    
    
    UIImage *theimage = [UIImage imageWithContentsOfFile:imgtoreturn];
    
    
    return theimage;
    
}

@end
