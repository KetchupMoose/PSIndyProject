//
//  HashtagSearchViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-28.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "HashtagSearchViewController.h"

@interface HashtagSearchViewController ()

@end

@implementation HashtagSearchViewController

NSArray *hashobjs;
 NSInteger maxhashcount = 0;
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
    
     self.hashtagSelectionBox.delegate = self;
	// Do any additional setup after loading the view.
    
    //show a list of the most common hashtags
   
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    TopBarViewController *tb;
    tb=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tb];
    
    [self.topbar addSubview:tb.view];
    
    self.topbar.backgroundColor = [UIColor clearColor];
    
    
    tb.view.frame = self.topbar.bounds;
    
    
    NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"blue-backgroundnosections" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *myb = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myb]];

    
    //do a query by count and display those
    hashobjs = [self queryforHashtags];
  
    
[self layouthashtags:hashobjs];
    
    //make them clickable to do a search with
    
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


- (void) layouthashtags:(NSArray *) hashes
{
    
    float ypos;
    float xpos;
    float btnmargin;
    float xwidth;
    float xmargin;
    float maxheight;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        ypos = 120;
        xpos = 10;
       btnmargin = 5;
        xwidth = 300;
        xmargin = 5;
         maxheight = 350;
        
        
    }
    else
    {
        ypos = 250;
        xpos = 10;
        btnmargin = 10;
        xwidth = 600;
        xmargin = 10;
        maxheight = 800;
    }
    
  
    
    
    int tag = 1;
    
   
    

   
    float heightsofar;
    float heightadaptor;
    
 
    
    if (hashes.count ==0)
    {
        
        UILabel *NoStuff = [[UILabel alloc] initWithFrame:CGRectMake(10,150,220,50)];
        NoStuff.text = @"No Categories Retrieved";
        NoStuff.tag = 1;
        
        [self.view addSubview:NoStuff];
        
    }
    
    for (PFObject *hash in hashes)
    {
        NSNumber *hshnum = [hash objectForKey:@"hashcount"];
        
        NSInteger hshint = [hshnum integerValue];
        
        if(hshint>=maxhashcount)
        {
            maxhashcount = hshint;
        }
    }
    
    
    for (PFObject *hash in hashes)
    {
        
        
        
        NSNumber *hshnum = [hash objectForKey:@"hashcount"];
        
        NSInteger hshint = [hshnum integerValue];
        
        CGSize btnsize = [self sizeForTag:hshint];
        
        CGRect btnframe = CGRectMake(xpos, ypos, btnsize.width, btnsize.height);
        
        
        
      //  NSLog(@"new cell left: %f", btnframe.origin.x);
       // NSLog(@"new cell top: %f", btnframe.origin.y);
       // NSLog(@"new cell width: %f", btnframe.size.width);
        NSLog(@"new cell height: %f", btnframe.size.height);
        
        
        UIButton *hashbutton = [[UIButton alloc] initWithFrame:btnframe];
        
        NSString *btnTitle = [hash objectForKey:@"hashstring"];
         NSString *hshnumtext = [hshnum stringValue];
        NSString *paren = @" (";
        NSString *parenend = @")";
        
        NSString *btnstring1 = [btnTitle stringByAppendingString:paren];
        NSString *btnstring2 = [hshnumtext stringByAppendingString:parenend];
        
        NSString *fullbtnstring = [btnstring1 stringByAppendingString:btnstring2];
        //hashbutton.titleLabel.numberOfLines = 1;
        
        UIFont *sysfont= [UIFont systemFontOfSize:10];
        NSString *familyName = sysfont.familyName;
        
        UIFont *fontforbtn = [self findAdaptiveFontWithName:familyName forbtnSize:btnsize withMinimumSize:10];
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *tcolor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];

        [hashbutton setTitleColor:tcolor forState:UIControlStateNormal];

        [hashbutton.titleLabel setFont:fontforbtn];
        
        hashbutton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
        
         //hashbutton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        
        [hashbutton setTitle:fullbtnstring forState:UIControlStateNormal];
        
        [hashbutton sizeToFit];
        
        [hashbutton setBackgroundColor: [UIColor whiteColor]];
        
        
        //CGRect lblframe = CGRectMake(btnframe.origin.x+lblxmargin + btnsize.width,btnframe.origin.y,25,btnsize.height);
        
        
        //UILabel *hashcount = [[UILabel alloc] initWithFrame:lblframe];
        
    
       
        
        //hashcount.text =hshnumtext;
        
       // hashcount.font = fontforbtn;
        //hashcount.textColor = tcolor;
        
        
        hashbutton.tag = tag;
        
       
        
         [hashbutton addTarget:self action:@selector(hashButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
       // hashcount.tag = 1;
        
        
        hashbutton.layer.cornerRadius = 10; // this value vary as per your desire
        hashbutton.clipsToBounds = YES;
        
        [self.view addSubview:hashbutton];
        //[self.view addSubview:hashcount];
        
        //NSLog(@"new btn left: %f", hashbutton.frame.origin.x);
       // NSLog(@"new btn top: %f", hashbutton.frame.origin.y);
       // NSLog(@"new btnwidth: %f", hashbutton.frame.size.width);
        NSLog(@"new btn height: %f", hashbutton.frame.size.height);
        
       //set height adaptor if it's the first cell or if it's the first new cell in a row
        if(tag==1)
        {
            heightadaptor = hashbutton.frame.size.height;
            heightsofar = heightadaptor;
        }
        
        
        if(xpos==10)
        {
            //this cell becomes the new height adaptor
            heightadaptor = hashbutton.frame.size.height;
        NSLog(@"%f",heightadaptor);
        
        heightsofar = heightsofar+heightadaptor;
        
       
        }
        
        
        xpos = xpos+ hashbutton.frame.size.width + xmargin;
        
        if((xpos +hashbutton.frame.size.width)>xwidth)
        {
            xpos = 10;
            //change this to add to y pos from the first time item for each row since it's the biggest.
            ypos = ypos + heightadaptor + btnmargin;
            if (heightsofar>maxheight)
            {
                return;
            }
            
        }
        else
        {
            //not first of row, dont reset height
            
        }
        
        
        tag = tag+1;
        
    }
}

- (void) layouthashtagstrending:(NSArray *) hashes
{
    float ypos;
    float xpos;
    float btnmargin;
    float xwidth;
    float xmargin;
    float maxheight;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        ypos = 120;
        xpos = 10;
        btnmargin = 5;
        xwidth = 300;
        xmargin = 5;
        maxheight = 350;
        
        
    }
    else
    {
        ypos = 250;
        xpos = 10;
        btnmargin = 10;
        xwidth = 600;
        xmargin = 10;
        maxheight = 800;
    }
    
    
    
    
    int tag = 1;
    

    float heightsofar;
    float heightadaptor;
    
    
    
    if (hashes.count ==0)
    {
        
        UILabel *NoStuff = [[UILabel alloc] initWithFrame:CGRectMake(10,150,220,50)];
        NoStuff.text = @"No Categories Retrieved";
        NoStuff.tag = 1;
        
        [self.view addSubview:NoStuff];
        
    }
    
    for (PFObject *hash in hashes)
    {
        NSNumber *hshnum = [hash objectForKey:@"hashcount"];
        
        NSInteger hshint = [hshnum integerValue];
        
        if(hshint>=maxhashcount)
        {
            maxhashcount = hshint;
        }
    }
    
    
    for (PFObject *hash in hashes)
    {
        
        
        
        NSNumber *hshnum = [hash objectForKey:@"hashcount"];
        
        NSInteger hshint = [hshnum integerValue];
        
        CGSize btnsize = [self sizeForTag:hshint];
        
        CGRect btnframe = CGRectMake(xpos, ypos, btnsize.width, btnsize.height);
        
        
        
        //  NSLog(@"new cell left: %f", btnframe.origin.x);
        // NSLog(@"new cell top: %f", btnframe.origin.y);
        // NSLog(@"new cell width: %f", btnframe.size.width);
        NSLog(@"new cell height: %f", btnframe.size.height);
        
        
        UIButton *hashbutton = [[UIButton alloc] initWithFrame:btnframe];
        
        NSString *btnTitle = [hash objectForKey:@"hashstring"];
        NSString *hshnumtext = [hshnum stringValue];
        NSString *paren = @" (";
        NSString *parenend = @")";
        
        NSString *btnstring1 = [btnTitle stringByAppendingString:paren];
        NSString *btnstring2 = [hshnumtext stringByAppendingString:parenend];
        
        NSString *fullbtnstring = [btnstring1 stringByAppendingString:btnstring2];
        //hashbutton.titleLabel.numberOfLines = 1;
        
        UIFont *sysfont= [UIFont systemFontOfSize:10];
        NSString *familyName = sysfont.familyName;
        
        UIFont *fontforbtn = [self findAdaptiveFontWithName:familyName forbtnSize:btnsize withMinimumSize:10];
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *tcolor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        
        [hashbutton setTitleColor:tcolor forState:UIControlStateNormal];
        
        [hashbutton.titleLabel setFont:fontforbtn];
        
        hashbutton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
        
        //hashbutton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        
        [hashbutton setTitle:fullbtnstring forState:UIControlStateNormal];
        
        [hashbutton sizeToFit];
        
        [hashbutton setBackgroundColor: [UIColor whiteColor]];
        
        
        //CGRect lblframe = CGRectMake(btnframe.origin.x+lblxmargin + btnsize.width,btnframe.origin.y,25,btnsize.height);
        
        
        //UILabel *hashcount = [[UILabel alloc] initWithFrame:lblframe];
        
        
        
        
        //hashcount.text =hshnumtext;
        
        // hashcount.font = fontforbtn;
        //hashcount.textColor = tcolor;
        
        
        hashbutton.tag = tag;
        
        
        
        [hashbutton addTarget:self action:@selector(hashButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        // hashcount.tag = 1;
        
        
        hashbutton.layer.cornerRadius = 10; // this value vary as per your desire
        hashbutton.clipsToBounds = YES;
        
        [self.view addSubview:hashbutton];
        //[self.view addSubview:hashcount];
        
        //NSLog(@"new btn left: %f", hashbutton.frame.origin.x);
        // NSLog(@"new btn top: %f", hashbutton.frame.origin.y);
        // NSLog(@"new btnwidth: %f", hashbutton.frame.size.width);
        NSLog(@"new btn height: %f", hashbutton.frame.size.height);
        
        //set height adaptor if it's the first cell or if it's the first new cell in a row
        if(hashbutton.frame.size.height>heightadaptor)
        {
            heightadaptor = hashbutton.frame.size.height;
            
        }
        
        
        if(xpos==10)
        {
            //this cell becomes the new height adaptor
            heightadaptor = hashbutton.frame.size.height;
            NSLog(@"%f",heightadaptor);
            
            heightsofar = heightsofar+heightadaptor;
            
            
        }
        
        
        xpos = xpos+ hashbutton.frame.size.width + xmargin;
        
        if((xpos +hashbutton.frame.size.width)>xwidth)
        {
            xpos = 10;
            //change this to add to y pos from the first time item for each row since it's the biggest.
            ypos = ypos + heightadaptor + btnmargin;
            
            
            
            if (heightsofar>maxheight)
            {
                return;
            }
            
        }
        else
        {
            //not first of row, dont reset height
            
        }
        
        
        tag = tag+1;
        
    }
}

-(UIFont *)findAdaptiveFontWithName:(NSString *)fontName forbtnSize:(CGSize)labelSize withMinimumSize:(NSInteger)minSize
{
    UIFont *tempFont = nil;
    NSString *testString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSInteger tempMin = minSize;
    NSInteger tempMax = 256;
    NSInteger mid = 0;
    NSInteger difference = 0;
    
    while (tempMin <= tempMax) {
        @autoreleasepool {
            mid = tempMin + (tempMax - tempMin) / 2;
            tempFont = [UIFont fontWithName:fontName size:mid];
            difference = labelSize.height - [testString sizeWithFont:tempFont].height;
            
            if (mid == tempMin || mid == tempMax) {
                if (difference < 0) {
                    return [UIFont fontWithName:fontName size:(mid - 1)];
                }
                
                return [UIFont fontWithName:fontName size:mid];
            }
            
            if (difference < 0) {
                tempMax = mid - 1;
            } else if (difference > 0) {
                tempMin = mid + 1;
            } else {
                return [UIFont fontWithName:fontName size:mid];
            }
        }
    }
    
    return [UIFont fontWithName:fontName size:mid];
}

//function needs context information on what the biggest hashtag is.
- (CGSize) sizeForTag:(NSInteger) tagcount
{
    float baseheight = 37.5;
    float basewidth = 93.75;
    
   
   // NSLog(@"heres the tagcount: %i",tagcount);
    
    float tcount = (float)tagcount;
    float maxhcount = (float)maxhashcount;
    
    float sizeratio = tcount/maxhcount;
    
    float newheight = baseheight*sizeratio;
    float newwidth = basewidth;
    
    CGSize sizereturn = CGSizeMake(newwidth, newheight);
    
    return sizereturn;
    
}
     



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//specific to the search textbox
- (IBAction)userEdited:(id)sender {
    
    UITextField *txty = sender;
    
    [txty resignFirstResponder];
    
    //get text, do the search, show a view controller with images
    NSString *hashtext = self.hashtagSelectionBox.text;
    
    //keep an eye on this, it might cause strict type errors later with more controls
   for (UIButton* blah in self.view.subviews)
   {
       if (blah.tag >0)
       {
           [blah removeFromSuperview];
       }
   }
    
    
    
    hashobjs = [self queryforHashtagsWithString:hashtext];
    [self layouthashtags:hashobjs];
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
   
    
    //get text, do the search, show a view controller with images
    NSString *hashtext = textField.text;
    
    //keep an eye on this, it might cause strict type errors later with more controls
    for (UIButton* blah in self.view.subviews)
    {
        if (blah.tag >0)
        {
            [blah removeFromSuperview];
        }
    }
    
    hashobjs = [self queryforHashtagsWithString:hashtext];
    [self layouthashtags:hashobjs];
}

- (IBAction)trendingPress:(id)sender {
    
    for (UIButton* blah in self.view.subviews)
    {
        if (blah.tag >0)
        {
            [blah removeFromSuperview];
        }
    }
    
    
    
    //show trending hashtags
    hashobjs = [self queryforNewHashtags];
    [self layouthashtagstrending:hashobjs];
    
    
}

-(NSArray *)queryforHashtags
{
    PFQuery *query = [PFQuery queryWithClassName:@"funHashtagCollection"];
    
    //later change this to be not equal to and boolean flagged for sale.
    //[query whereKey:@"status" equalTo:@"forSale"];
    [query orderByDescending:@"hashcount"];
    
    [query includeKey:@"funPhotoObjPointers"];
    
    query.limit = 25;
    // Dispose of any resources that can be recreated.
    
    return query.findObjects;
}

-(NSArray *)queryforHashtagsWithString:(NSString *) hashstring
{
    PFQuery *query = [PFQuery queryWithClassName:@"funHashtagCollection"];
    
    //later change this to be not equal to and boolean flagged for sale.
    //[query whereKey:@"status" equalTo:@"forSale"];
    [query orderByDescending:@"hashcount"];
    [query whereKey:@"hashstring" containsString:hashstring];
    [query includeKey:@"funPhotoObjPointers"];
    query.limit = 25;
    // Dispose of any resources that can be recreated.
    
    return query.findObjects;
}

-(NSArray *)queryforNewHashtags
{
    PFQuery *query = [PFQuery queryWithClassName:@"funHashtagCollection"];
    
    //later change this to be not equal to and boolean flagged for sale.
    //[query whereKey:@"status" equalTo:@"forSale"];
    [query orderByDescending:@"hashcount"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"funPhotoObjPointers"];
    query.limit = 25;
    // Dispose of any resources that can be recreated.
    
    return query.findObjects;
}


//delegate method for sr delegate
- (void)dismissResults:(UIViewController *)dismissingvc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hashButtonTouched:(id)sender {
    
    
    // display view controller here.  this triggers the next segue
    [self performSegueWithIdentifier:@"searchresults" sender:sender];
    
    
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"searchresults"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		SearchResultsViewController
        *ssrViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
		ssrViewController.srdelegate = self;
        
        UIButton *blah = sender;
        NSInteger btnindex = blah.tag;
        //removing 1 becaus of change to remove only buttons with tags >0.
        btnindex= btnindex -1;
        NSLog(@"here is the index %i",btnindex);
        
        PFObject *selectedhash = [hashobjs objectAtIndex:btnindex];
        NSArray *hashfunobjs = [selectedhash objectForKey:@"funPhotoObjPointers"];
        
        ssrViewController.parseobjs = hashfunobjs;
        
	}
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)backBtn:(id)sender
{
    [self.hsvcDelegate dismissSearchVC:self];
    
    
}


@end
