//
//  InternetOfflineViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-12-07.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "InternetOfflineViewController.h"

@interface InternetOfflineViewController ()

@end

@implementation InternetOfflineViewController

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
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"background-login" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    UIImage *b = [self imageWithImage:bgimage scaledToSize:self.view.bounds.size];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:b]];
    
    NSString *logoImageFile = [[NSBundle mainBundle] pathForResource:@"logo-login" ofType:@"png"];
    
    UIImage *logoImg = [UIImage imageWithContentsOfFile:logoImageFile];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:logoImg];
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
            logoImgView.frame = CGRectMake(46.0f, 52.0f, 250.0f, 188.0f);
      }
    
    else
    {
         logoImgView.frame = CGRectMake(-550.0f, 552.0f, 500.0f, 376.0f);
    }
 
    
    [self.view addSubview:logoImgView];
    
    UIButton *reconnectBtn = [[UIButton alloc] init];
    
    
    NSString *filebtn = [[NSBundle mainBundle] pathForResource:@"blackbutton" ofType:@"png"];
    UIImage *btnimg = [UIImage imageWithContentsOfFile:filebtn];
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
             reconnectBtn.frame=CGRectMake(25,300,270,50);
     }
    else
    {
        reconnectBtn.frame=CGRectMake(225,600,270,50);
    }

    
    
    [reconnectBtn setImage:btnimg forState:UIControlStateNormal];
    
    
    UILabel *internetrequired = [[UILabel alloc] initWithFrame:CGRectMake(25,240,270,50)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
       internetrequired.font =[UIFont fontWithName:@"CooperBlackStd" size:12];
    }
    else
    {
        internetrequired.font =[UIFont fontWithName:@"CooperBlackStd" size:18];
        internetrequired.frame = CGRectMake(170,550,400,50);
        
    }
    
    
    internetrequired.text = @"Internet Connection Required to Play";
    internetrequired.backgroundColor = [UIColor clearColor];
    internetrequired.textAlignment = NSTextAlignmentCenter;
    
    
    
    [self.view addSubview:internetrequired];
    
    UILabel *reconlabel = [[UILabel alloc] initWithFrame:reconnectBtn.bounds];
    
    reconlabel.text = @"Reconnect";
    
    reconlabel.backgroundColor = [UIColor clearColor];
    
    reconlabel.textColor = [UIColor whiteColor];
    
    reconlabel.textAlignment = NSTextAlignmentCenter;
    
    reconlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:14];
    
    [reconnectBtn addTarget:self action:@selector(tryreconnect:) forControlEvents:UIControlEventTouchUpInside];
    
    [reconnectBtn addSubview:reconlabel];
    
    [self.view addSubview:reconnectBtn];
    
    
}

-(BOOL) tryreconnect:(id)sender
{
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(myad.internet==YES)
    {
        NSLog(@"yes");
        
        [self.view removeWithZoomOutAnimation:1 option:UIViewAnimationOptionCurveEaseIn];
        return YES;
    }
    else
    {
         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internet Error", nil) message:NSLocalizedString(@"Internet Connection Still Not Detected", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return NO;
        
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

@end
