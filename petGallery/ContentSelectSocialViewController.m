//
//  ContentSelectSocialViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-10.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "ContentSelectSocialViewController.h"

//facebook imports
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import <parse/parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ContentSelectSocialViewController ()
{
   // Pinterest*  _pinterest;
}

@end

@implementation ContentSelectSocialViewController

@synthesize accessToken;
@synthesize selectedparsepic;
@synthesize theimage;
BOOL contentLiked;
MBProgressHUD *HUD;
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
	}

-(void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:YES];
    
    // Do any additional setup after loading the view.
    
    //self.fbNumLabel.backgroundColor = [UIColor clearColor];
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
          self.fbNumLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:11];
          self.twitNumLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:11];
          self.pintNumLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:11];
          self.msgNumLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:11];
          
          self.favesLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:12];
          self.getGoldLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:12];
      }
    else
        
    {
        self.fbNumLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.twitNumLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.pintNumLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        self.msgNumLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:15];
        
        self.favesLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:16];
        self.favesLabel.numberOfLines =2;
        
        self.getGoldLabel.font =  [UIFont fontWithName:@"CooperBlackStd" size:20];
    }
   
    
    self.twitNumLabel.text = @"0";
    
    self.pintNumLabel.text = @"0";
    
    
    if([selectedparsepic objectForKey:@"funPhotoFBs"])
    {
        self.fbNumLabel.text = [[selectedparsepic objectForKey:@"funPhotoFBs"] stringValue];
        
    }
    else
    {
        self.fbNumLabel.text = @"0";
    }
    
    
    if([selectedparsepic objectForKey:@"funPhotoEmails"])
    {
        self.msgNumLabel.text = [[selectedparsepic objectForKey:@"funPhotoEmails"] stringValue];
        
    }
    else
    {
        self.msgNumLabel.text = @"0";
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) doOpenGraphShareAction:(NSMutableDictionary<FBGraphObject>*) pvote
{
    //vote on the picture
    
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    action[@"picture"] = pvote;
    
    [FBRequestConnection startForPostWithGraphPath:@"me/picksomethingapp:shared"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     // handle the result
                                     
                                     NSLog(@"this is the post result:%@ ", [result objectForKey:@"id"]);
                                 }];
    
}

- (void)startpicOpenGraph
{
    
    NSString *imglink = [selectedparsepic objectForKey:@"imgLink"];
    NSString *imgurl;
    if(imglink.length<2)
    {
        
        //consider getting the image data from the UIImage instead..
        PFFile *mydata = [selectedparsepic objectForKey:@"imageFile"];
        imgurl = mydata.url;
        
        
    }
    else
    {
        imgurl =imglink;
        
        
    }
 
        NSString *captionstring= [self.selectedparsepic objectForKey:@"Caption"];
   
    NSMutableDictionary<FBGraphObject> *pic =
    [FBGraphObject openGraphObjectForPostWithType:@"picksomethingapp:picture"
                                            title:@"this was the favorite"
                                            image:imgurl
                                              url:@"https://itunes.apple.com/us/app/pick-something/id757934816"
                                      description:captionstring];;
    
    pic[@"create_object"] = @"1";
    pic[@"fbsdk:create_object"] = @"1";
    
    
    [FBRequestConnection startForPostWithGraphPath:@"me/objects/picksomethingapp:picture"
                                       graphObject:pic
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     // handle the result
                                     NSLog(@"this is the result:%@ ", [result objectForKey:@"id"]);
                                     //NSString *resultID= [result objectForKey:@"id"];
                                     
                                     [self doOpenGraphShareAction:pic];
                                 }];
}

- (IBAction)fbButton:(id)sender {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Sharing To Facebook";
    [HUD show:YES];
    
    HUD.progress = (float)25/100;

    
    
    //FBSession *myfbsession = [PFFacebookUtils session];
    
  accessToken = [[[PFFacebookUtils session] accessTokenData] accessToken];
    
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
   // NSString *message = [NSString stringWithFormat:@"I think this is cool"];
    
    NSData *imageData;
    NSString *imglink = [selectedparsepic objectForKey:@"imgLink"];
    NSString *imgurl;
    if(imglink.length<2)
    {
       
        //consider getting the image data from the UIImage instead..
        //PFFile *mydata = [selectedparsepic objectForKey:@"imageFile"];
        //imgurl = mydata.url;
        imageData =  UIImageJPEGRepresentation(theimage.image, 1.0);
        
    }
    else
    {
        //imgurl =imglink;
        
        //get imagedata from the UIImage.
         imageData =  UIImageJPEGRepresentation(theimage.image, 1.0);
    }

    NSString *captionstring= [self.selectedparsepic objectForKey:@"Caption"];
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
    
    // Save image.
    [imageData writeToFile:filePath atomically:YES];
   
    
   // NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gold_coin_single_64" ofType:@"png"];
    
    [request addFile:filePath forKey:@"file"];
    [request setPostValue:captionstring forKey:@"message"];
    [request setPostValue:accessToken forKey:@"access_token"];
    [request setDidFinishSelector:@selector(sendToPhotosFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)sendToPhotosFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *photoId = [responseJSON objectForKey:@"id"];
    NSLog(@"Photo id is: %@", photoId);
    
    NSString *urlString = [NSString stringWithFormat:
                           @"https://graph.facebook.com/%@?access_token=%@", photoId,
                           [accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *newRequest = [ASIHTTPRequest requestWithURL:url];
    [newRequest setDidFinishSelector:@selector(getFacebookPhotoFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
    
}

- (void)getFacebookPhotoFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Photo: %@", responseString);
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    
    NSString *link = [responseJSON objectForKey:@"link"];
    if (link == nil) return;
    NSLog(@"Link to photo: %@", link);
    
    NSString *imglink = [selectedparsepic objectForKey:@"imgLink"];
    NSString *imgurl;
    if(imglink.length<2)
    {
        
        //consider getting the image data from the UIImage instead..
        PFFile *mydata = [selectedparsepic objectForKey:@"imageFile"];
        imgurl = mydata.url;
        
        
    }
    else
    {
        imgurl =imglink;
        
        
    }

    NSString *photolink = imgurl;
    
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    [newRequest setPostValue:@"Think You Know What's Popular?" forKey:@"message"];
    //[newRequest setPostValue:@"Check out the tutorial!" forKey:@"name"];
    [newRequest setPostValue:@"Pick Something!" forKey:@"name"];
    
    NSString *captionstring= [self.selectedparsepic objectForKey:@"Caption"];
    [newRequest setPostValue:@"The trivia game for popular images." forKey:@"caption"];
    [newRequest setPostValue:captionstring forKey:@"description"];
    [newRequest setPostValue:@"https://itunes.apple.com/us/app/pick-something/id757934816" forKey:@"link"];
    [newRequest setPostValue:photolink forKey:@"picture"];
    [newRequest setPostValue:accessToken forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(postToWallFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
    
}

- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];
    NSLog(@"Post id is: %@", postId);
    
    
    [HUD hide:YES];
    PlayerData *sharedData = [PlayerData sharedData];
    
    float prog = [sharedData AddGoldXPScoreVote:20 withXP:0 withScore:0];
    [self popupShareText];
    
    //add to the number of FB's for this PF Object.
    PFObject *thisobj = selectedparsepic;
    [thisobj incrementKey:@"funPhotoShares"];
    
    [thisobj incrementKey:@"funPhotoFBs"];
    [thisobj saveInBackground];
    
    
    UIAlertView *av = [[UIAlertView alloc]
                        initWithTitle:@"Sucessfully posted to photos & wall!"
                        message:@"Check out your Facebook to see!"
                        delegate:nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil] ;
	[av show];
    
}

- (IBAction)twitterButton:(id)sender {
    UIAlertView *av = [[UIAlertView alloc]
                       initWithTitle:@"Coming Soon!"
                       message:@"Coming Soon!"
                       delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] ;
	[av show];
}

- (IBAction)pintButton:(id)sender {
 
    UIAlertView *av = [[UIAlertView alloc]
                       initWithTitle:@"Coming Soon!"
                       message:@"Coming Soon!"
                       delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] ;
	[av show];
    
   /*
    PFFile *myfile = [self.selectedparsepic objectForKey:@"imageFile"];
    
    NSString *captionstring= [self.selectedparsepic objectForKey:@"Caption"];
    
    
    NSString *myimgURL = myfile.url;
    
        
    NSURL *imgurl = [NSURL URLWithString:myimgURL];
      NSURL *srcurl = [NSURL URLWithString:@"http://placekitten.com/500/400"];
    
    [_pinterest createPinWithImageURL:imgurl
                            sourceURL:srcurl
                          description:captionstring];
    */
}

- (IBAction)msgButton:(id)sender {
    
    
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        //get selected content link.
        PFObject *thisobj = selectedparsepic;

        NSString *imglink = [thisobj objectForKey:@"imgLink"];
        NSString *imgurl;
        if(imglink.length<2)
        {
            PFFile *mydata = [thisobj objectForKey:@"imageFile"];
            imgurl = mydata.url;
            
        }
        else
        {
            imgurl =imglink;
        }

        NSString *msgstring = [@"I thought you'd love this picture I found on Pick Something for iPhone, hope you enjoy!  " stringByAppendingString:imgurl];
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Check out this picture from Pick Something for iPhone!"];
        [mailViewController setMessageBody:msgstring isHTML:NO];
        [self presentViewController:mailViewController animated:YES completion:nil];
        
      
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
       
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    //add some gold to the user and play the gold animation
    PlayerData *sharedData = [PlayerData sharedData];
     PFObject *thisobj = selectedparsepic;
    float prog;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            prog = [sharedData AddGoldXPScoreVote:20 withXP:0 withScore:0];
            [self popupShareText];
            [thisobj incrementKey:@"funPhotoShares"];
            [thisobj incrementKey:@"funPhotoEmails"];
            [thisobj saveInBackground];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
  
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


-(void) popupShareText
{
    //present the win or loss text with a quick pop-out
    UILabel *feedbacktext = [[UILabel alloc] init];
    feedbacktext.font = [UIFont fontWithName:@"CooperBlackStd" size:15];
    feedbacktext.numberOfLines = 2;
    feedbacktext.text = @"Thanks for Share! +20 Gold";
    
    feedbacktext.shadowColor = [UIColor blackColor];
    feedbacktext.backgroundColor = [UIColor clearColor];
    feedbacktext.frame = CGRectMake(0,60,320, 40);
    feedbacktext.textColor = [UIColor yellowColor];
    feedbacktext.textAlignment = NSTextAlignmentCenter;
    
    [self animatetextsizeincrease:feedbacktext];
    
}

- (IBAction)faveButton:(id)sender {
   HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Adding To Faves";
    [HUD show:YES];
    
    HUD.progress = (float)25/100;

    
    
    
    //add the content to the PFObject funPhotoLike
    NSString *selectedObject = selectedparsepic.objectId;
    
    //fix this later for the warning
    NSLog(@"This is the fun photo object: %@", selectedObject);
    
    
    //add user rating
    PFUser *user = [PFUser currentUser];
    
    
    PFObject *userLike = [PFObject objectWithClassName:@"funPhotoLike"];
    [userLike setObject:user forKey:@"contentLiker"];
    [userLike setObject:selectedparsepic forKey:@"funPhotoObject"];
    [userLike setObject:selectedparsepic.objectId forKey:@"funPhotoObjectString"];
    
    [userLike saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The gameScore saved successfully.
            NSLog(@"This got saved on funPhotoLikes: %@", selectedparsepic.objectId);
            
            //do some code to get the current average rating and give the user some gold + xp for submitting their rating
            
            [HUD hide:YES];
            
            
            [self setObjectFaved];
            
            
            
            [self popupLikedText];
            
            
            //future:add some sort of progress hub here
        } else {
            // There was an error saving the gameScore.
            NSLog(@"Error: %@", error);
        }
    }];

    
}

-(void) setObjectFaved
{
    
    self.favesLabel.text = @"I Faved This!";
    
    
    
    self.faveBtn.enabled = NO;
    
    
}


-(void) popupLikedText
{
    //present the win or loss text with a quick pop-out
    UILabel *feedbacktext = [[UILabel alloc] init];
    feedbacktext.font = [UIFont fontWithName:@"CooperBlackStd" size:15];
    feedbacktext.numberOfLines = 2;
    feedbacktext.text = @"Added to Faves!";
    
    feedbacktext.shadowColor = [UIColor blackColor];
    feedbacktext.backgroundColor = [UIColor clearColor];
    feedbacktext.frame = CGRectMake(0,30,320, 40);
    feedbacktext.textColor = [UIColor redColor];
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



- (IBAction)redditButton:(id)sender {
}
@end
