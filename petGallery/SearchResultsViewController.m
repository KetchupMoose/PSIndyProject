//
//  SearchResultsViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-28.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController


#define PADDING_TOP 0 // For placing the images nicely in the grid
#define PADDING 4
#define THUMBNAIL_COLS 4
#define THUMBNAIL_WIDTH 75
#define THUMBNAIL_HEIGHT 75

@synthesize viewController = _viewController;
@synthesize srdelegate;
@synthesize parseobjs;

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
  
    TopBarViewController *tb;
    tb=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tb];
    
    [self.topbar addSubview:tb.view];
    
    self.topbar.backgroundColor = [UIColor clearColor];
    
    tb.view.frame = self.topbar.bounds;
    
    allImages = [[NSMutableArray alloc] init];
    
    NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"blue-backgroundnosections" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *myb = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myb]];
    NSString *resnum = [NSString stringWithFormat:@"%i",parseobjs.count];
    
    self.resultsNumLabel.text = [resnum stringByAppendingString:@" Results"];
    
    [self setUpImages:parseobjs];
    
	// Do any additional setup after loading the view.
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

- (void)downloadAllImages
{
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // If there are photos, we start extracting the data
        // Save a list of object IDs while extracting this data
        
        NSMutableArray *newObjectIDArray = [NSMutableArray array];
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        if (objects.count > 0) {
            for (PFObject *eachObject in objects) {
                [newObjectIDArray addObject:[eachObject objectId]];
            }
        }
    }
     ];
}

- (IBAction)backbtnpress:(id)sender {
    
    [self.srdelegate dismissResults:self];
    
}


- (void)setUpImages:(NSArray *)images
{
    // Contains a list of all the BUTTONS
    allImages = [images mutableCopy];
    // Remove old grid
            for (UIView *view in [photoScrollView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            
            // Create the UIImageViews necessary for each image in the grid
            for (int i = 0; i < [images count]; i++) {
                PFObject *eachObject = [images objectAtIndex:i];
                
                NSString *imglink = [eachObject objectForKey:@"imgLink"];
                NSString *imgurl;
                if(imglink.length<2)
                {
                    PFFile *mydata = [eachObject objectForKey:@"imageFile"];
                    imgurl = mydata.url;
                    
                }
                else
                {
                    imgurl =imglink;
                }
                
                UIImageView *myimgview = [[UIImageView alloc] init];
                
                UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
                
                
                NSString *imgtype = [eachObject objectForKey:@"imgURType"];
                
                
                
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height == 480)
                {
                    // iPhone Classic
                    if([imgtype isEqualToString:@"image/gif"])
                    {
                        imgurl = @"http://i.imgur.com/cwAB9XA.jpg";
                    }
                    
                }
                
                [myimgview setImageWithURL:[NSURL URLWithString:imgurl]usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle];
                
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
               
               
                button.showsTouchWhenHighlighted = YES;
                [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                button.frame = CGRectMake(THUMBNAIL_WIDTH * (i % THUMBNAIL_COLS) + PADDING * (i % THUMBNAIL_COLS) + PADDING,
                                          THUMBNAIL_HEIGHT * (i / THUMBNAIL_COLS) + PADDING * (i / THUMBNAIL_COLS) + PADDING + PADDING_TOP,
                                          THUMBNAIL_WIDTH,
                                          THUMBNAIL_HEIGHT);
                myimgview.frame =CGRectMake(THUMBNAIL_WIDTH * (i % THUMBNAIL_COLS) + PADDING * (i % THUMBNAIL_COLS) + PADDING,
                                            THUMBNAIL_HEIGHT * (i / THUMBNAIL_COLS) + PADDING * (i / THUMBNAIL_COLS) + PADDING + PADDING_TOP,
                                            THUMBNAIL_WIDTH,
                                            THUMBNAIL_HEIGHT);
                //button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [button setTitle:[eachObject objectId] forState:UIControlStateReserved];
                [photoScrollView addSubview:myimgview];
                
                [photoScrollView addSubview:button];
            }
            
            // Size the grid accordingly
            int rows = images.count / THUMBNAIL_COLS;
            if (((float)images.count / THUMBNAIL_COLS) - rows != 0) {
                rows++;
            }
            int height = THUMBNAIL_HEIGHT * rows + PADDING * rows + PADDING + PADDING_TOP;
            
            photoScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
            photoScrollView.clipsToBounds = YES;
    
}

- (void)buttonTouched:(id)sender {
    
    NSInteger btnindex = [sender tag];
    //invoke something with the selected cell.
    NSLog(@"selectedcellindex: %i", btnindex);

    //going to try manually instantiating the nav & view controllers and pushing them
    FrontPageSelectionViewController * fps;
    
    //UINavigationController *navcontrol = [self.storyboard instantiateViewControllerWithIdentifier:@"navfrontdetails"];
    
    
    
    fps = [self.storyboard instantiateViewControllerWithIdentifier:@"frontPageSelection"];
    
    PFObject *selectedContent = [self.parseobjs objectAtIndex:btnindex];
    
    
    fps.delegate = self;
    fps.selectedContent= selectedContent;
    fps.parseObjects = [self.parseobjs mutableCopy];
    
    NSNumber *indNum= [NSNumber numberWithInt:(btnindex)];
    
    fps.parseobjindex = indNum;
    
    [self.navigationController pushViewController:fps animated:YES];
    
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
	HUD = nil;
}

- (NSArray *)parseimages:(id)sender {
    
}

- (void)FrontPageSelectionViewControllerBackToFrontPage:
(FrontPageSelectionViewController *)controller
{
     [self.navigationController popViewControllerAnimated:YES];
}



@end

