//
//  PlayerProfileViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-01.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PlayerProgressViewController.h"

@interface PlayerProgressViewController ()

@end

@implementation PlayerProgressViewController
@synthesize badgesbtn;
@synthesize collectionsbtn;
@synthesize leaderboardsbtn;
@synthesize collectionstext;
@synthesize badgestext;
@synthesize leaderboardstext;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLayoutSubviews
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            //leave as normal
            
        }
        if(result.height == 568)
        {
            // iPhone 5
            //give stage extra dimensions
            NSLog(@"iphone 5s settings buy stuff page");
            
            //[submnewtext setFrame:CGRectMake(55,132, 200, 50)];
            
           
            [badgesbtn setFrame:CGRectMake(badgesbtn.frame.origin.x,badgesbtn.frame.origin.y +40,badgesbtn.frame.size.width,badgesbtn.frame.size.height)];
            
            [leaderboardsbtn setFrame:CGRectMake(leaderboardsbtn.frame.origin.x,leaderboardsbtn.frame.origin.y +60,leaderboardsbtn.frame.size.width,leaderboardsbtn.frame.size.height)];
            
            [collectionsbtn setFrame:CGRectMake(collectionsbtn.frame.origin.x,collectionsbtn.frame.origin.y +20,collectionsbtn.frame.size.width,collectionsbtn.frame.size.height)];
            
            [collectionstext setFrame:CGRectMake(collectionstext.frame.origin.x,collectionstext.frame.origin.y +15,collectionstext.frame.size.width,collectionstext.frame.size.height)];
            
            [badgestext setFrame:CGRectMake(badgestext.frame.origin.x,badgestext.frame.origin.y +54,badgestext.frame.size.width,badgestext.frame.size.height)];
            
            [leaderboardstext setFrame:CGRectMake(leaderboardstext.frame.origin.x,leaderboardstext.frame.origin.y +38,leaderboardstext.frame.size.width,leaderboardstext.frame.size.height)];
            
            
        }
    }
}
- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    TopBarViewController *tpvc;
    
    tpvc=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tpvc];
    
    tpvc.topbardelegate = self;
    
    
    [self.topbar addSubview:tpvc.view];
    
    
    self.topbar.backgroundColor = [UIColor clearColor];
    
    
    tpvc.view.frame = self.topbar.bounds;
    
    
    NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"progressbackground" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *b = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:b]];
    
    UILabel *mycolltext = self.collectionstext;
    UILabel *mybadgestext = self.badgestext;
    UILabel *leaderstext = self.leaderboardstext;

    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        mycolltext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
        mybadgestext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
        leaderstext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
    }
    else
    {
        mycolltext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
        mybadgestext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
        leaderstext.font = [UIFont fontWithName:@"CooperBlackStd" size:27];
    }
 

        
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
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

-(IBAction) Badges:(id)sender
{
    //do a segue
    
    UIAlertView *av = [[UIAlertView alloc]
                       initWithTitle:@"Coming Soon!"
                       message:@"Badges Coming Soon!"
                       delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] ;
	[av show];

    
    //[self performSegueWithIdentifier: @"badgesegue" sender:self];
    
}
-(IBAction) Leaderboard:(id)sender
{
    
    LeaderboardsViewController *ldboardsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"leaderboardsvc"];
    
    ldboardsvc.lvcdelegate = self;
    [self.navigationController pushViewController:ldboardsvc animated:YES];
    
    
}
-(IBAction) Collections:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]
                       initWithTitle:@"Coming Soon!"
                       message:@"Collections Coming Soon!"
                       delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] ;
	[av show];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"badgesegue"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		BadgesViewController
        *bViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
        
		bViewController.bvcdelegate = self;
        
	}
}

-(void) dismissBVC:(BadgesViewController *) bvc
{
    //dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) dismissLVC:(LeaderboardsViewController *) lvc
{
      [self.navigationController popViewControllerAnimated:YES];
}


@end
