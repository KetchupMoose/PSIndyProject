//
//  CategorySelectViewController.m
//  Pick Something
//
//  Created by Macbook on 2014-01-31.
//  Copyright (c) 2014 bricorp. All rights reserved.
//

#import "CategorySelectViewController.h"
#include <stdlib.h>

@interface CategorySelectViewController ()

@end

@implementation CategorySelectViewController

@synthesize catbutton1;
@synthesize catbutton2;
@synthesize catbutton3;
@synthesize catbutton4;
@synthesize csdelegate;
@synthesize topBar;
@synthesize bgImage;

NSArray *categories;
NSMutableArray *selectedCats;
NSMutableArray *challengesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSMutableArray *)getFourRandomLessThan:(int)M {
    NSMutableArray *uniqueNumbers = [[NSMutableArray alloc] init];
    int r;
    while ([uniqueNumbers count] < 4) {
        r = arc4random() % M; // ADD 1 TO GET NUMBERS BETWEEN 1 AND M RATHER THAN 0 and M-1
        if (![uniqueNumbers containsObject:[NSNumber numberWithInt:r]]) {
            [uniqueNumbers addObject:[NSNumber numberWithInt:r]];
        }
    }
    return uniqueNumbers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    TopBarViewController *tpvc;
    challengesArray = [NSMutableArray alloc];
    
    
    tpvc=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tpvc];
    
    //tpvc.topbardelegate = self;
    
    
    [self.topBar addSubview:tpvc.view];
    
    self.topBar.backgroundColor = [UIColor clearColor];
    
    tpvc.view.frame = self.topBar.bounds;
 
    //resize image
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"wsnew-background" ofType:@"png"];
    UIImage *bgimage = [UIImage imageWithContentsOfFile:fileName];
    
    UIImage *b = [self imageWithImage:bgimage scaledToSize:self.view.bounds.size];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:b]];
    
    
    categories = [NSArray arrayWithObjects: @"Internet", @"Movies", @"Celebs", @"Art", @"Sports", @"Animals", @"Food", @"Television", @"Selfies", @"Fashion",@"Brands",@"Cartoons",@"Music", nil];
   
    
    int catlen = categories.count;
   
    selectedCats = [self getFourRandomLessThan:catlen];
    
    UIImage *catbtn1img;
    UIImage *catbtn2img;
    UIImage *catbtn3img;
    UIImage *catbtn4img;
   
    
    int firstcat = [[selectedCats objectAtIndex:0] integerValue];
     int secondcat = [[selectedCats objectAtIndex:1] integerValue];
     int thirdcat = [[selectedCats objectAtIndex:2] integerValue];
     int fourthcat = [[selectedCats objectAtIndex:3] integerValue];
   
    
    NSString *file1 = [[NSBundle mainBundle] pathForResource:[self imageFileForInteger:firstcat] ofType:@"png"];
    
    catbtn1img = [UIImage imageWithContentsOfFile:file1];
    
    [self.catbutton1 setBackgroundImage:catbtn1img forState:UIControlStateNormal];
    
    NSString *file2 = [[NSBundle mainBundle] pathForResource:[self imageFileForInteger:secondcat] ofType:@"png"];
    
    catbtn2img = [UIImage imageWithContentsOfFile:file2];
    
    [self.catbutton2 setBackgroundImage:catbtn2img forState:UIControlStateNormal];
    
    
    NSString *file3 = [[NSBundle mainBundle] pathForResource:[self imageFileForInteger:thirdcat] ofType:@"png"];
    
    catbtn3img = [UIImage imageWithContentsOfFile:file3];
    
    [self.catbutton3 setBackgroundImage:catbtn3img forState:UIControlStateNormal];
    
    [self.catbutton2 setBackgroundImage:catbtn2img forState:UIControlStateNormal];
    
    NSString *file4 = [[NSBundle mainBundle] pathForResource:[self imageFileForInteger:fourthcat] ofType:@"png"];
    
    catbtn4img = [UIImage imageWithContentsOfFile:file4];
    
    [self.catbutton4 setBackgroundImage:catbtn4img forState:UIControlStateNormal];
    
    
    
    //show a loading screen
    
    //query to get 4 random categories & 7 questions from each
    
    //if they dont have any left on that category, when they click it say to come back later
    
    
    
    
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


-(NSString *)imageFileForInteger:(int) choice
{
    NSString *fileString;
    if(choice==0)
    {
        fileString = @"Cat_btn_thisorthat";
        return fileString;
        
    }
    if(choice==1)
    {
        fileString = @"Cat_btn_movies";
        return fileString;
        
    }
    if(choice==2)
    {
        fileString = @"Cat_btn_popularcelebs";
        return fileString;
        
    }
    if(choice==3)
    {
        fileString = @"Cat_btn_coolart";
        return fileString;
        
    }
    if(choice==4)
    {
        fileString = @"Cat_btn_sports";
        return fileString;
        
    }
    if(choice==5)
    {
        fileString = @"Cat_btn_cuteanimals";
        return fileString;
        
    }
    if(choice==6)
    {
        fileString = @"Cat_btn_food";
        return fileString;
        
    }
    if(choice==7)
    {
        fileString = @"Cat_btn_television";
        return fileString;
        
    }
    if(choice==8)
    {
        fileString = @"Cat_btn_selfies";
        return fileString;
        
    }
    if(choice==9)
    {
        fileString = @"Cat_btn_fashion";
        return fileString;
        
    }
    if(choice==10)
    {
        fileString = @"Cat_btn_brands";
        return fileString;
        
    }
    if(choice==11)
    {
        fileString = @"Cat_btn_cartoons";
        return fileString;
        
    }
    if(choice==12)
    {
        fileString = @"Cat_btn_music";
        return fileString;
        
    }
    fileString = @"Cat_btn_thisorthat";
    return fileString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//do a query for the category they selected.

- (IBAction)cat1press:(id)sender {
    
    NSString *selectedCategoryString = categories[[selectedCats[0] integerValue] ];
    NSLog(selectedCategoryString);
    
    //query for a group of 7 challenge pool objects with this category name.
    
    [self getSelectedChallenges:selectedCategoryString];
    
    
    
}

- (IBAction)cat2press:(id)sender {
      NSString *selectedCategoryString = categories[[selectedCats[1] integerValue] ];
     NSLog(selectedCategoryString);
    
     [self getSelectedChallenges:selectedCategoryString];
    
}

- (IBAction)cat3press:(id)sender {
      NSString *selectedCategoryString = categories[[selectedCats[2] integerValue] ];
     NSLog(selectedCategoryString);
    
     [self getSelectedChallenges:selectedCategoryString];
    
}

- (IBAction)cat4press:(id)sender {
    //  NSString *selectedCategoryString = categories[[selectedCats[3] integerValue] ];
    NSString *selectedCategoryString = categories[1];
     [self getSelectedChallenges:selectedCategoryString];
}

-(void) getSelectedChallenges:(NSString *) category
{
    

//modify UserVoteChallenges to include a category column
//modify funPhotoChallengePool to include category column.

//vote history appears in UserVoteChallenges
PFUser *user = [PFUser currentUser];

PFQuery * cpquery = [PFQuery queryWithClassName:@"funPhotoChallengePool"];

PFQuery *votehistoryquery = [PFQuery queryWithClassName:@"UserVoteChallenges"];
[votehistoryquery whereKey:@"Voter" equalTo:user];
[votehistoryquery whereKey:@"Category" equalTo:category];
    
[votehistoryquery includeKey:@"funPhotoChallengePool"];
[votehistoryquery orderByDescending:@"createdAt"];
votehistoryquery.limit = 500;
//NSNumber *rank1 = [NSNumber numberWithInt:1];

//this part isn't working..debug
//workaround explained here
//https://parse.com/questions/trouble-with-nested-query-using-objectid
[cpquery whereKey:@"objectId" doesNotMatchKey:@"funPhotoChallengePoolString" inQuery:votehistoryquery];
//[cpquery whereKey:@"rank" equalTo:rank1];
[cpquery whereKey:@"Category" equalTo:category];
    
[cpquery orderByDescending:@"createdAt"];
[cpquery includeKey:@"funPhotoObj1"];
[cpquery includeKey:@"funPhotoObj2"];
[cpquery includeKey:@"funPhotoObj3"];
[cpquery includeKey:@"funPhotoObj4"];

int querylimit = 7;

NSInteger *querylimitnum = &querylimit;

cpquery.limit = *querylimitnum ;

//NSArray *freepassobjs;
[cpquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if  (!error && objects.count>=1)
    {
        //[challengesArray removeAllObjects];
        
        //[challengesArray addObjectsFromArray:objects];
        
        //set the data in its delegate, the main voting controller.
        [self.csdelegate setParentChallenges:objects];
        
        
        [self.csdelegate CategoryPick:self];
        
        
        //remove the category select & start loading the content voting controller.
        
        
        
    }
    else
    {
         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Out of Category Content", nil) message:NSLocalizedString(@"Choose another category, you've reached the end of this one!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
}];
}

-(void) viewDidLayoutSubviews
{
if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        // iPhone Classic
    }
    if(result.height == 568)
    {
        // iPhone 5
        //give stage extra dimensions
        
        CGRect btn1frame = self.catbutton1.frame;
        
        btn1frame.origin.y = btn1frame.origin.y+40;
        
        self.catbutton1.frame = btn1frame;
        
        CGRect btn2frame = self.catbutton2.frame;
        
        btn2frame.origin.y = btn2frame.origin.y+40;
        
        self.catbutton2.frame = btn2frame;
        
        CGRect btn3frame = self.catbutton3.frame;
        
        btn3frame.origin.y = btn3frame.origin.y+40;
        
        self.catbutton3.frame = btn3frame;
        
        CGRect btn4frame = self.catbutton4.frame;
        
        btn4frame.origin.y = btn4frame.origin.y+40;
        
        self.catbutton4.frame = btn4frame;
        
    }
}
}

@end
