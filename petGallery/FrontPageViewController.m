//
//  FrontPageViewController.m
//  petGallery
//
//  Created by mac on 7/25/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "FrontPageViewController.h"
#import "FrontPagePFQueryTableViewController.h"
#import "FPCollectionViewCell.h"
#import "TopBarViewController.h"
#import "HashtagSearchViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImageView+Scaling.h"

@interface FrontPageViewController ()


@end

@implementation FrontPageViewController
int selectedTopBarQuery = 0;
//FrontPagePFQueryTableViewController * fpqtvc ;

int numofrows;
TopBarViewController *topbar;
int selectedmode;
NSInteger selectionIndex;
MBProgressHUD *HUD;
NSInteger QueryMoreCount;

@synthesize stage;
@synthesize topbarcontainer;

@synthesize contentObjectsArray;
@synthesize tbtvc;

static int curveValues[] = {
    UIViewAnimationOptionCurveEaseInOut,
    UIViewAnimationOptionCurveEaseIn,
    UIViewAnimationOptionCurveEaseOut,
    UIViewAnimationOptionCurveLinear };

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    if(self.contentObjectsArray.count>1)
    {
        return;
    }
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];

}


- (void)viewDidDisappear:(BOOL)animated {
    [self.tbtvc removeFromSuperview];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    
   /*
    UITabBarController *tabBarController = (UITabBarController *)self.view.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    
    CGSize size = tabBar.frame.size;
    
    UIImage *tabbarbackground;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        tabbarbackground = [UIImage imageNamed:@"new-bottom-bar-browse.png"];
    }
    else
    {
        tabbarbackground = [UIImage imageNamed:@"pad-bottom-bar-browse.png"];
    }
    UIImage *tabbarresized = [self imageWithImage:tabbarbackground scaledToSize:size];
    
    [tabBar setBackgroundImage:tabbarresized];
    */

    //[self.tbtvc reloadData:tbtvc];
    
    //[self.stage addSubview:tbtvc];
  
    
    
    if (self.contentObjectsArray.count >1)
    {
      
        //add the subview back with a fade
        [self.stage addSubviewWithFadeAnimation:tbtvc duration:1.0 option:UIViewAnimationOptionCurveEaseIn];
        
        return;
    }
    
    
    NSLog(@"doing initial query for twotable");

    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
    [query includeKey:@"creator"];
    [query orderByDescending:@"createdAt"];
    
    int querylimit = 150;
    
    NSInteger *querylimitnum = &querylimit;
    
    query.limit = *querylimitnum;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.contentObjectsArray = [objects mutableCopy];
        [self.stage addSubviewWithFadeAnimation:tbtvc duration:1.5 option:UIViewAnimationOptionCurveEaseIn];
        [self.tbtvc reloadData:tbtvc];
        [self.view bringSubviewToFront:self.FrontNavigationBar];
        
        
        [HUD hide:YES];
    }];

    
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    SDWebImageManager.sharedManager.delegate = self;
    self.navigationController.navigationBar.translucent = YES;
    float fNewHeight = 28;
    
    //changing the height of the navigation bar so the ios 6 version fits in the same frame as the ios 7.
    
    CGRect frame= self.FrontNavigationBar.frame;
    [self.FrontNavigationBar setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, fNewHeight)];
   
    NSString *navbarfilename = [[NSBundle mainBundle] pathForResource:@"browse-top-bar" ofType:@"png"];
    
    UIImage *navbarimage = [UIImage imageWithContentsOfFile:navbarfilename];
    
    UIImage *mynavbar = [self imageWithImage:navbarimage scaledToSize:self.FrontNavigationBar.frame.size];
    
    [self.FrontNavigationBar setBackgroundImage:mynavbar forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    //46 49 146 navy blue for browse title
    UIColor *mytbcolor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:146/255.0 alpha:1];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:17], UITextAttributeFont,
                                mytbcolor, UITextAttributeTextColor,
                                nil];
    [self.FrontNavigationBar setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:mytbcolor forKey:UITextAttributeTextColor];
    [self.FrontNavigationBar setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"blue-background" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *myb = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myb]];
    
    self.stage.backgroundColor = [UIColor clearColor];
    
    selectedmode = 1;
    
    //brian note: maybe I should rewrite this to load just as a view and not a view within a viewcontroller...
	// Do any additional setup after loading the view.
    
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
            NSLog(@"iphone 5s settings front page");
            
            
            self.stage.bounds = CGRectMake(self.stage.bounds.origin.x,self.stage.bounds.origin.y,self.stage.bounds.size.width, self.stage.bounds.size.height +40);
            self.stage.frame = CGRectMake(self.stage.frame.origin.x, 82, self.stage.frame.size.width,self.stage.frame.size.height);
            
        }
    }

    
   tbtvc = [[PSCollectionView alloc] initWithFrame:self.stage.bounds];
    
    tbtvc.delegate = self; // This is for UIScrollViewDelegate
    
    tbtvc.collectionViewDelegate = self;
    tbtvc.collectionViewDataSource = self;
    
    
   // tbtvc.backgroundColor = [UIColor colorWithRed:(210/255.0) green:(210/255.0) blue:(210/255.0) alpha:1];
 tbtvc.autoresizingMask = ~UIViewAutoresizingNone;
    
    // Specify number of columns for both iPhone and iPad
    
    tbtvc.numColsPortrait = 2;
    tbtvc.numColsLandscape = 2;
    
    tbtvc.tag=43;
    
    //tbtvc.frame=self.stage.bounds;
    
    //changing this to loading in background
    
    
      //self.contentObjectsArray = [objects mutableCopy];
      //code to add top bar to container
            
            topbar=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
            
            [self addChildViewController:topbar];
            
            [self.topbarcontainer addSubview:topbar.view];
            
            topbar.view.frame = self.topbarcontainer.bounds;
            
            //need to make this accessible
            //[topbar getProfileInfo];
 
   
    //BrianNOte--investigate why this is not centering correctly.
    CGRect btnframe = self.browsebtn.frame;
    
    btnframe.size = CGSizeMake(130/2,24);
    
    self.browsebtn.frame = btnframe;
    
    NSString *btnfileName = [[NSBundle mainBundle] pathForResource:@"browse-button" ofType:@"png"];
    
    UIImage *browsebtnimg =[UIImage imageWithContentsOfFile:btnfileName];
    
    UIImage *mybrowseimg = [self imageWithImage:browsebtnimg scaledToSize:btnframe.size];

    [self.browsebtn setBackgroundImage:mybrowseimg forState:UIControlStateNormal];
    
    
    /*
    UILabel *browsebtntext = [[UILabel alloc] initWithFrame:self.browsebtn.bounds];
    browsebtntext.text = @"Browse #";
    browsebtntext.font = [UIFont fontWithName:@"CooperBlackStd" size:12];
    browsebtntext.backgroundColor = [UIColor clearColor];
    browsebtntext.textAlignment = NSTextAlignmentCenter;
    
    [self.browsebtn addSubview:browsebtntext];
    */
    
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



- (IBAction)FrontNavigationBarChange:(id)sender {
    NSInteger barnum ;
    
    barnum= self.FrontNavigationBar.selectedSegmentIndex;
    NSLog(@"retrieved bar number: %i", barnum);
    
  selectedTopBarQuery = barnum;
    
    int qnum = self.FrontNavigationBar.selectedSegmentIndex;
    
    
    
    if(barnum ==2)
    {
        
        //bring up the search page
        
        
    }
    else
    {
          [self selectFrontPageQuery:(qnum)];
    }
    
    
       //fpqtvc.frontPageQuery = [self selectFrontPageQuery:barnum];
    
    
    //[fpqtvc clear];
    
    //update this in the future to show a progress bar hud while it is performing the query
    
    
    //[fpqtvc loadObjects];
    
}
- (void)selectFrontPageQuery:(int)queryselection
{
     NSLog(@"startingqueryselection: %i", queryselection);
    NSLog(@"reviewing selected mode: %i", selectedmode);
    if (selectedmode ==1)
    {
        if(queryselection ==0)
        {
            NSLog(@"doing query 0 for two table");
            
            for (UIView *subview in [self.stage subviews]) {
                
                if (subview.tag == 43){
                    
                    [subview removeFromSuperview];
                    
                }
            }
            
            PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
            [query includeKey:@"creator"];
            [query orderByDescending:@"createdAt"];
            
            int querylimit = 150;
            
            NSInteger *querylimitnum = &querylimit;
            
            query.limit = *querylimitnum ;
            
            
                
                tbtvc = [[TwoTableCollectionView alloc] initWithFrame:self.stage.frame];
                
                tbtvc.delegate = self; // This is for UIScrollViewDelegate
                
                
                tbtvc.collectionViewDelegate = self;
                tbtvc.collectionViewDataSource = self;
                
                
                tbtvc.backgroundColor = [UIColor colorWithRed:(210/255.0) green:(210/255.0) blue:(210/255.0) alpha:1];
                tbtvc.autoresizingMask = ~UIViewAutoresizingNone;
                
                // Specify number of columns for both iPhone and iPad
                
                tbtvc.numColsPortrait = 2;
                tbtvc.numColsLandscape = 2;
                
                tbtvc.tag=43;
                
                
                [self.stage addSubviewWithFadeAnimation:tbtvc duration:1.5 option:UIViewAnimationOptionCurveEaseIn];
                
                tbtvc.frame=self.stage.bounds;
                
                //warning...fix
                self.contentObjectsArray=[[query findObjects] mutableCopy];
            
                
            //endquery
            
        }

        if(queryselection ==1)
        {
            NSLog(@"doing query 2 for two table");
            
            for (UIView *subview in [self.stage subviews]) {
                
                if (subview.tag == 43){
                    
                    [subview removeFromSuperview];
                    
                }
            }
            
            //get only content from 10 days ago.
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
            
            [components setHour:-[components hour]];
            [components setMinute:-[components minute]];
            [components setSecond:-[components second]];
            NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
            
            // [components setHour:-24];
            // [components setMinute:0];
            //[components setSecond:0];
            // NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
            
            components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
            
            //[components setDay:([components day] - ([components weekday] - 1))];
            //NSDate *thisWeek  = [cal dateFromComponents:components];
            
            //[components setDay:([components day] - 7)];
            //NSDate *lastWeek  = [cal dateFromComponents:components];
            
            [components setDay:([components day] - 10)];
            NSDate *tendaysago  = [cal dateFromComponents:components];
            
            
            [components setDay:([components day] - ([components day] -1))];
            NSDate *thisMonth = [cal dateFromComponents:components];
            
            [components setMonth:([components month] - 1)];
            NSDate *lastMonth = [cal dateFromComponents:components];
            
            // NSLog(@"today=%@",today);
            //NSLog(@"yesterday=%@",yesterday);
            // NSLog(@"thisWeek=%@",thisWeek);
            //NSLog(@"lastWeek=%@",lastWeek);
            NSLog(@"tendaysago=%@",tendaysago);
            
            NSLog(@"thisMonth=%@",thisMonth);
            NSLog(@"lastMonth=%@",lastMonth);
            
            
            //changing for now to just show content ranked by the highest content value
            PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
            [query includeKey:@"creator"];
           // NSNumber *numforquery = [NSNumber numberWithInt:0];
            
            [query orderByDescending:@"contentValue"];
            [query whereKey:@"createdAt" greaterThan:tendaysago];
            
            
            //[query whereKey:@"TopWeekly" greaterThan:numforquery];
            
            
            
            
            int querylimit = 100;
            
            NSInteger *querylimitnum = &querylimit;
            
            query.limit = *querylimitnum ;
            
           
            
            tbtvc = [[TwoTableCollectionView alloc] initWithFrame:self.stage.frame];
            
            tbtvc.delegate = self; // This is for UIScrollViewDelegate
            
            
            tbtvc.collectionViewDelegate = self;
            tbtvc.collectionViewDataSource = self;
            
            
            tbtvc.backgroundColor = [UIColor colorWithRed:(210/255.0) green:(210/255.0) blue:(210/255.0) alpha:1];
            tbtvc.autoresizingMask = ~UIViewAutoresizingNone;
            
            // Specify number of columns for both iPhone and iPad
            
            tbtvc.numColsPortrait = 2;
            tbtvc.numColsLandscape = 2;
            
            tbtvc.tag=43;
            
            
             [self.stage addSubviewWithFadeAnimation:tbtvc duration:1.5 option:UIViewAnimationOptionCurveEaseIn];
            
            tbtvc.frame=self.stage.bounds;
            
            //warning...fix
            
            self.contentObjectsArray=[[query findObjects] mutableCopy];
            
            
        }
        }
}

-(void)QueryForEndOfContent
{
    
   
    
    
}

//PSCollectionView Data Source Required Methods


//modifying this to show 150 + the count of the query more...
- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    
    //change this to a property I can set via the results of the query.
    
    return self.contentObjectsArray.count;
    
    
    
}
//method for getting the content type of an image

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}
//this method allows me to transform the downloaded image before it is used by the UIImageView.

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
   
    
    int maxw;
    int maxh;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
         maxw = 145;
         maxh = 1000;
     }
    else
    {
        maxw = 350;
        maxh = 1000;
    }
   
    
    
    CGSize sizeobj = image.size;
    
    
    CGSize sizeforimgcontainer = [self scalesize:sizeobj maxWidth:maxw maxHeight:maxh];
    //reduce the image to its proper size.
    
    image=[self imageWithImage:image scaledToSize:sizeforimgcontainer];
    
    SDImageCache *sd;
    NSString *myString = [imageURL absoluteString];
    [sd removeImageForKey:myString];
    
    
    return image;
  
    
}




- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index withRect:(CGRect) recttouse {
    
    
    FPCollectionViewCell *thefpcell = (FPCollectionViewCell *)
    [collectionView dequeueReusableViewForClass:[FPCollectionViewCell class]];
    
    thefpcell.frame = recttouse;
    
    if (thefpcell == nil) {
        
        
        thefpcell = [[FPCollectionViewCell alloc] initWithFrame:recttouse];
     
        NSLog(@"creating this cell: %i", index);
          UILabel *cellText = [[UILabel alloc] initWithFrame:CGRectMake(2,0,143,20)];
           thefpcell.cellText.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:9];
         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         {
             thefpcell.cellText.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:15];
             thefpcell.cellText.numberOfLines = 2;
             
             cellText.frame = CGRectMake(2,0,348,40);
             
         }
        thefpcell.cellText = cellText;
        thefpcell.cellText.textAlignment = NSTextAlignmentCenter;
        
        
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,20,recttouse.size.width, recttouse.size.height-20)];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            cellImage.frame = CGRectMake(0,40,recttouse.size.width,recttouse.size.height-40);
            
        }
        
        thefpcell.cellImage = cellImage;
        
         thefpcell.backgroundColor = [UIColor whiteColor];
       
        
        thefpcell.cellText.backgroundColor = [UIColor clearColor];
        
        
        [thefpcell addSubview:cellText];
        [thefpcell addSubview:cellImage];
        
        }
    
    
    [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{

        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            thefpcell.cellText.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:15];
            thefpcell.cellText.frame = CGRectMake(2,0,348,40);
             thefpcell.cellText.numberOfLines = 2;
        }
        else
        {
            thefpcell.cellText.frame = CGRectMake(2,0,143,20);
             thefpcell.cellText.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:9];
            
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            thefpcell.cellImage.frame = CGRectMake(0,40,recttouse.size.width,recttouse.size.height-40);
            
        }
        else
        {
            thefpcell.cellImage.frame = CGRectMake(0,20,recttouse.size.width, recttouse.size.height-20);
        }
        
                
            PFObject *thisobj = [self.contentObjectsArray objectAtIndex:index];
            
            
            thefpcell.cellText.text = [thisobj objectForKey:@"Caption"];
            
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

        
            UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
            
        NSString *imgtype = [thisobj objectForKey:@"imgURType"];
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            if([imgtype isEqualToString:@"image/gif"])
            {
                imgurl = @"http://i.imgur.com/cwAB9XA.jpg";
            }
            
        }
        
        
        
        
        [thefpcell.cellImage setImageWithURL:[NSURL URLWithString:imgurl] usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle ];
        
    
        //[thefpcell.cellImage setImageWithURL:[NSURL URLWithString:imgurl] scaleToSize:YES];
        
         
        thefpcell.layer.cornerRadius = 9.0;
        thefpcell.layer.masksToBounds = YES;
        
        }]];
    
    
    //NSLog(@"got it: %i", index);
    
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    
    
    return thefpcell;
}

//return 0 for height if it's outside of the visible index..


- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    
    NSInteger visibleIndex = 100*QueryMoreCount;
    
    if(index <visibleIndex)
    {
        //NSLog(@"returning 0 for %i", index);
        
       // return 0;
        
    }
    
    //the index needs to change to be based on the QueryMoreCount
    //index = index-(100*QueryMoreCount);
    
    
    PFObject *selectedContent = [contentObjectsArray objectAtIndex:(index)];
    
    
    float imgheight = [[selectedContent  objectForKey:@"imgHeight"] floatValue];
    float imgwidth = [[selectedContent objectForKey:@"imgWidth"] floatValue];
    
    
    int maxw;
    int maxh;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        maxw = 145;
        maxh = 1000;
    }
    else
    {
        maxw = 350;
        maxh = 1000;
    }
    
    CGSize currentsize = CGSizeMake(imgwidth,imgheight);
    CGSize sizeobj = currentsize;
    
    
    CGSize sizeforimgcontainer = [self scalesize:sizeobj maxWidth:maxw maxHeight:maxh];
    
    //need to take this image size and calculate the proper fuggin aspect ratio to get the real height to show now, WIGGA.
    
    CGSize newsize = sizeforimgcontainer;
    
    //NSLog(@"original height: %ld", (long)imgheight);
   // NSLog(@"new max height: %ld", (long)newsize.height);
    
   // NSLog(@"original width: %ld", (long)imgwidth);
    //NSLog(@"new max width: %ld", (long)newsize.width);
    
    //need to factor in size of other controls.  label + button vs size of image.
    
    CGFloat retval = newsize.height +20.0;
    
   // NSLog(@"returning real height for %i", index);
    return retval;
}

-(CGSize)scalesize:(CGSize)imgsize maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    
    CGFloat width = imgsize.width;
    
    CGFloat height = imgsize.height;
    
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
    
    //make sure to enforce a maximum height on upload so you dont get fkin nonsense.
    
    CGSize size = newsize;
    
    
    return size;
    
}


//PScollectionview optional delegate methods

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    
    //invoke something with the selected cell.
    NSLog(@"selectedcellindex: %i", index);
    
    selectionIndex = index;
    
    
    //going to try manually instantiating the nav & view controllers and pushing them
        FrontPageSelectionViewController * fps;
    
    //UINavigationController *navcontrol = [self.storyboard instantiateViewControllerWithIdentifier:@"navfrontdetails"];
    
    
    
      fps = [self.storyboard instantiateViewControllerWithIdentifier:@"frontPageSelection"];
    
    PFObject *selectedContent = [self.contentObjectsArray objectAtIndex:selectionIndex];
    
    NSLog(@"self%@",self);
    
    fps.delegate = self;
    fps.selectedContent= selectedContent;
    fps.parseObjects = self.contentObjectsArray;
    fps.fpsaccessmode = @"fp";
    
    NSNumber *indNum= [NSNumber numberWithInt:(index)];
    
    
    fps.parseobjindex = indNum;
    
    
    [self.navigationController pushViewController:fps animated:YES];
    
    
       //get the PF object selected and invoke a method to segue or popup another form from this cell..
    //Perform a segue.
    
    //[self performSegueWithIdentifier: @"twoPagetoDetailsSegue" sender:self];
    
};




- (void)FrontPageSelectionViewControllerBackToFrontPage:
(FrontPageSelectionViewController *)controller
{
   
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) dismissSearchVC:(HashtagSearchViewController *) hsvc;
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction) browsebtn:id
{
    //changing this to not perform a segue because I want to keep the tab bar controller instead..
    HashtagSearchViewController *searchvc = [self.storyboard instantiateViewControllerWithIdentifier:@"hashsearch"];
    
    searchvc.hsvcDelegate = self;
    
    [self.navigationController pushViewController:searchvc animated:YES];
    
    //[self performSegueWithIdentifier: @"seguesearch" sender:self];
    
   
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"seguesearch"]) {
        
        UINavigationController *navigationController =
        segue.destinationViewController;
        
        HashtagSearchViewController *hsvc = [[navigationController viewControllers] objectAtIndex:0];
        
        hsvc.hsvcDelegate = self;
        
        //[self viewDidDisappear:YES];
        
        
        // FrontPagePFQueryTableViewController * fpqsubView = fpqtvc.self;
        
        // fpqtvc.frontPageQuery= [self selectFrontPageQuery:(selectedTopBarQuery)];
        
        // [fpqtvc (fpqtvc.frontPageQuery)queryforTable];
        
        // do something with the AlertView's subviews here...
    }
    
    if ([segue.identifier isEqualToString:@"twoPagetoDetailsSegue"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		FrontPageSelectionViewController
        *FPSViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
        
        
        PFObject *selectedContent = [self.contentObjectsArray objectAtIndex:selectionIndex];
        
        NSLog(@"self%@",self);
        
		FPSViewController.delegate = self;
        FPSViewController.selectedContent= selectedContent;
        // add method to say destination petviewcontroller equals selected PFObject
	}
    
}
//pull 150 objects.  when the user arrives at the 125th piece of content...erase the first 100 objects of the array, and add 100 objects more. after that, add/erase every 100.

//index is kept to show the content by total count

//125, refresh.  array is now 100-250. (150)--100 for refresh

//225, refresh. array is now 200-350. (150)--100 diff for refresh

//325, refresh.  array is now 300-450. (150)--100 diff for refresh

- (void) queryForMore:(NSInteger)index WithDirection:(NSInteger) direction
{
    NSLog(@"querying for more");
    
    //get the pf object at the index and query for objects with created at in the right direction above or below that object.  delete the proper area out of the array.
    
    //check if count * the index is greater than what is displayed here
    NSInteger totalcount = 149+index;
    
    if(self.contentObjectsArray.count >totalcount)
    {
        return;
        
    }
    if(index>=self.contentObjectsArray.count)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The End!", nil) message:NSLocalizedString(@"This is the end of content, the end of the internet!  Come back later!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    if (direction==1)
    {
        NSInteger myindex = index -(100*QueryMoreCount);
        
        PFObject *myobj = [self.contentObjectsArray objectAtIndex:self.contentObjectsArray.count-1];
        
        PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
        [query includeKey:@"creator"];
        [query orderByDescending:@"createdAt"];
        [query whereKey:@"createdAt" lessThan:myobj.createdAt];
        
        int querylimit = 100;
        
        NSInteger *querylimitnum = &querylimit;
        
        query.limit = *querylimitnum ;

        
        
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            //delete the first 100 objects in contentobjects array, add these objects
        
            //[self.contentObjectsArray removeObjectsInRange:NSMakeRange(0,99)];
            
            [self.contentObjectsArray addObjectsFromArray:objects];
                    NSLog(@" adding this many objects:%i",objects.count);
                                                           
                    
                    
             NSLog(@"add and remove content done");
            NSLog(@"the count %i",self.contentObjectsArray.count);
            
            [self.tbtvc reloadData:tbtvc];
            
            QueryMoreCount = QueryMoreCount+1;
                              
                }];
        
        
    }
    else
    {
       /*
        NSInteger myindex = index -(100*QueryMoreCount);
        
        QueryMoreCount = QueryMoreCount-1;
        PFObject *myobj = [self.contentObjectsArray objectAtIndex:myindex];
        
        PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
        [query includeKey:@"creator"];
        [query orderByDescending:@"createdAt"];
        [query whereKey:@"createdAt" greaterThan:myobj.createdAt];
        
        int querylimit = 100;
        
        NSInteger *querylimitnum = &querylimit;
        
        query.limit = *querylimitnum ;
        
        
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            //going back up..
            //first delete the objects at the end of the array, from 51to150.
            //then push the new content to the beginning of the array
            //then add the old stuff back to the caboose
            [self.contentObjectsArray removeObjectsInRange:NSMakeRange(51,150)];
           
            
            NSArray *myarray = [self.contentObjectsArray mutableCopy];
            
            self.contentObjectsArray=[objects mutableCopy];
            [self.contentObjectsArray addObjectsFromArray:myarray];
            
            [self.contentObjectsArray addObjectsFromArray:objects];
            
            
            NSLog(@"add and remove content done");
            NSLog(@"the count %i",self.contentObjectsArray.count);

            [self.tbtvc reloadData:tbtvc];

            QueryMoreCount = QueryMoreCount-1;
        }];
        */
    }
    
}


@end
