//
//  LevelUpViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-07.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "LevelUpViewController.h"

@interface LevelUpViewController ()


@end

@implementation LevelUpViewController

@synthesize lvlupdelegate;

@synthesize lvlupgold;
@synthesize lvluplevel;
@synthesize lvlupgems;
@synthesize lvlupheart;

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
    
    //play an animation and show a silly view
    
    CelebrateParticleView *cpv = [[CelebrateParticleView alloc] initWithFrame:self.view.frame particlePosition:self.view.frame.origin];
    
    [self.view addSubview:cpv];
    
    NSTimeInterval decaytime= 3.0;
    
    [cpv decayOverTime:decaytime];
    
      NSString *fileName = [[NSBundle mainBundle] pathForResource:@"levelupbackground" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgimgview;
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
           bgimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,260,300)];
      }
   else
   {
       bgimgview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,520,600)];
   }
    
    bgimgview.contentMode = UIViewContentModeScaleAspectFit;
    
    bgimgview.image = bgimage;
    
    [self.view addSubview:bgimgview];
    [self.view sendSubviewToBack:bgimgview];
    
    
    //for iphone 3.5 inch retina
    //shared margin
    //float xmarg = 15;
    
    CGRect goldrect;
    CGRect gemrect;
    CGRect heartrect;
    CGRect goldlabelrect;
    CGRect gemlabelrect;
    CGRect heartlabelrect;
    CGRect leveluplabelrect;
    CGRect levellabel2rect;
    CGRect okbtnrect;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
       goldrect = CGRectMake(34,136,54,54);
       gemrect = CGRectMake(goldrect.size.width +15+goldrect.origin.x,136,54,54);
       heartrect = CGRectMake(gemrect.size.width+gemrect.origin.x+15,136,54,54);
        
        goldlabelrect = CGRectMake(goldrect.origin.x,195,goldrect.size.width,20);
        gemlabelrect = CGRectMake(gemrect.origin.x,195,gemrect.size.width,20);
        heartlabelrect = CGRectMake(heartrect.origin.x,195,heartrect.size.width,20);
        
        leveluplabelrect = CGRectMake(0,36,260,24);
        levellabel2rect = CGRectMake(0,60,260,24);
        
        okbtnrect = CGRectMake(76,195+34,105,47);
    }
    else
    {
        goldrect = CGRectMake(68,272,108,108);
        gemrect = CGRectMake(goldrect.size.width +30+goldrect.origin.x,272,108,108);
        heartrect = CGRectMake(gemrect.size.width+gemrect.origin.x+30,272,108,108);
        
        goldlabelrect = CGRectMake(goldrect.origin.x,390,goldrect.size.width,40);
        gemlabelrect = CGRectMake(gemrect.origin.x,390,gemrect.size.width,40);
        heartlabelrect = CGRectMake(heartrect.origin.x,390,heartrect.size.width,40);
        
        leveluplabelrect = CGRectMake(0,72,520,48);
        levellabel2rect = CGRectMake(0,120,520,48);
        
        okbtnrect = CGRectMake(152,390+68,210,94);
    }
   
    
    
    
    UIImageView *goldicon = [[UIImageView alloc] initWithFrame:goldrect];
     UIImageView *gemicon = [[UIImageView alloc] initWithFrame:gemrect];
     UIImageView *hearticon = [[UIImageView alloc] initWithFrame:heartrect];
    
     NSString *fileNameg = [[NSBundle mainBundle] pathForResource:@"gold-icon" ofType:@"png"];
     NSString *fileNameg2 = [[NSBundle mainBundle] pathForResource:@"diamond-icon" ofType:@"png"];
     NSString *fileNameh = [[NSBundle mainBundle] pathForResource:@"heart-icon" ofType:@"png"];
    
    goldicon.image = [UIImage imageWithContentsOfFile:fileNameg];
      gemicon.image = [UIImage imageWithContentsOfFile:fileNameg2];
      hearticon.image = [UIImage imageWithContentsOfFile:fileNameh];
    
    goldicon.contentMode = UIViewContentModeScaleAspectFill;
      gemicon.contentMode = UIViewContentModeScaleAspectFill;
      hearticon.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *goldlabel = [[UILabel alloc] initWithFrame:goldlabelrect];
      UILabel *gemlabel = [[UILabel alloc] initWithFrame:gemlabelrect];
      UILabel *heartlabel = [[UILabel alloc] initWithFrame:heartlabelrect];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        goldlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
        gemlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
        heartlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:20];
    }
    else
    {
        goldlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
        gemlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
        heartlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:40];
    }
    
    
    goldlabel.textColor = [self colorFromHexString:@"7B50A0"];
    
    gemlabel.textColor = [self colorFromHexString:@"7B50A0"];
    
    heartlabel.textColor = [self colorFromHexString:@"7B50A0"];
    
    heartlabel.textAlignment = NSTextAlignmentCenter;
    goldlabel.textAlignment = NSTextAlignmentCenter;
    gemlabel.textAlignment = NSTextAlignmentCenter;
    
    goldlabel.text = [self.lvlupgold stringValue];
       gemlabel.text = [self.lvlupgems stringValue];
     heartlabel.text = [self.lvlupheart stringValue];
    
    
    UILabel *lvltext1 = [[UILabel alloc] initWithFrame:leveluplabelrect];
    UILabel *lvltext2 = [[UILabel alloc] initWithFrame:levellabel2rect];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        lvltext1.font = [UIFont fontWithName:@"CooperBlackStd" size:24];
        lvltext2.font =[UIFont fontWithName:@"CooperBlackStd" size:24];
    }
    else
    {
        lvltext1.font = [UIFont fontWithName:@"CooperBlackStd" size:48];
        lvltext2.font =[UIFont fontWithName:@"CooperBlackStd" size:48];
    }
    
    
    lvltext1.textColor = [self colorFromHexString:@"7B50A0"];
     lvltext2.textColor = [self colorFromHexString:@"7B50A0"];
    
    lvltext1.textAlignment = NSTextAlignmentCenter;
    lvltext2.textAlignment = NSTextAlignmentCenter;
    
    lvltext1.text = [@"Level " stringByAppendingString:[lvluplevel stringValue]];
    
    lvltext2.text = @"Complete";
    
    UIButton *okbutton = [[UIButton alloc] initWithFrame:okbtnrect];
    
       NSString *fileNameok = [[NSBundle mainBundle] pathForResource:@"ok-button" ofType:@"png"];
    UIImage *okbtnimg = [UIImage imageWithContentsOfFile:fileNameok];
    
    [okbutton setBackgroundImage:okbtnimg forState:UIControlStateNormal];
    
    okbutton.contentMode = UIViewContentModeScaleAspectFit;
    
    [okbutton addTarget:self action:@selector(lvlupclosebutton:) forControlEvents:UIControlEventTouchUpInside];
    
    lvltext1.backgroundColor = [UIColor clearColor];
    lvltext2.backgroundColor = [UIColor clearColor];
    
    goldlabel.backgroundColor = [UIColor clearColor];
     gemlabel.backgroundColor = [UIColor clearColor];
     heartlabel.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:okbutton];
    
    
    [self.view addSubview:lvltext1];
    [self.view addSubview:lvltext2];
    
    
    
    [self.view addSubview:goldicon];
    [self.view addSubview:gemicon];
    [self.view addSubview:hearticon];
    
    
    [self.view addSubview:goldlabel];
    [self.view addSubview:heartlabel];
    [self.view addSubview:gemlabel];
     
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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

-(void) lvlupclosebutton:(id) sender {
    
    
    
    //self delegate dismiss thingy.
    [self.lvlupdelegate dismisslevelup:self];
    
}
@end
