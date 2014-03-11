//
// This is the template PFQueryTableViewController subclass file. Use it to customize your own subclass.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "MyPetDetailsViewController.h"
#import "GlobeParticleEmitter.h"
#import "MyPetsQueryTableViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "FrontPageSelectionViewController.h"


@implementation MyPetsQueryTableViewController
@synthesize displayMode;
@synthesize mypqtdelegate;

NSTimer * countdownTimer;
NSUInteger remainingTicks;
NSInteger sendIndex;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        
        // The key of the PFObject to display in the label of the default cell style
        
        
        //[self queryForTable];
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 100;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
            self.tableView.rowHeight = 341;
      }
  
    
  
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
   
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
    
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"funPhotoObject"];
    

    //change the query depending on the display mode
    if ([displayMode isEqual:@"submits"])
    {
        [query whereKey:@"creator" equalTo:user];
        [query includeKey:@"creator"];
        [query whereKey:@"createdAt" greaterThan:tendaysago];
        [query orderByDescending:@"contentValue"];
         
    }
    else
    {
        [query whereKey:@"owner" equalTo:user];
        [query includeKey:@"creator"];
        [query whereKey:@"createdAt" greaterThan:tendaysago];
        [query orderByDescending:@"contentValue"];
    }
        //later change this to be not equal to and boolean flagged for sale.
    
    //need method to call to reload table
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (MyPetsQueryUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"MyPetsCell";
    
    MyPetsQueryUITableViewCell *cell = (MyPetsQueryUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyPetsQueryUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"new cell");
        CGRect tmpFrame = cell.frame;
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            tmpFrame.origin.x = 5;
            tmpFrame.size.width = 310;
            tmpFrame.size.height = 339;
        }
      
        
        cell.frame = tmpFrame;
        
    }
    else
    {
        NSLog(@"reuseCell");
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    // Configure the cell
    //cell.textLabel.text = [object objectForKey:self.textKey];
    //cell.imageView.file = [object objectForKey:self.imageKey];
    
    // Configure the cell...
    
    //   Pet *ptab = [self.pets objectAtIndex:indexPath.row];
    
    //gets names and types from include key on query
   
    UILabel *toplabel = (UILabel *)[cell viewWithTag:1];
   // toplabel.text =    [object objectForKey:@"contentRanking"];
    
    
    //get image height & image width then size the img frame
    float imgheight = [[object  objectForKey:@"imgHeight"] floatValue];
    float imgwidth = [[object objectForKey:@"imgWidth"] floatValue];
    
    int maxw;
    int maxh;
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
         maxw = 145;
         maxh = 170;
     }
    else
    {
        maxw = 300;
        maxh = 360;
    }
 
    
    CGSize currentsize = CGSizeMake(imgwidth,imgheight);
    CGSize * sizeobj = &currentsize;
    
    CGSize *sizeforimgcontainer = [self scalesize:sizeobj maxWidth:maxw maxHeight:maxh];
    
    CGSize newsize = *sizeforimgcontainer;
    
    float imgcellxpos;
    
    
    if(newsize.width<maxw)
    {
        imgcellxpos = (maxw-newsize.width)/2;
    }
    else
    {
        imgcellxpos=0;
    }
    
    float imgypos = (maxh-newsize.height)/2;


    UIImageView *petimgview = (UIImageView *)[cell viewWithTag:13];
    NSString *imglink = [object objectForKey:@"imgLink"];
    NSString *imgurl;
    if(imglink.length<2)
    {
        PFFile *mydata = [object objectForKey:@"imageFile"];
        imgurl = mydata.url;
        
    }
    else
    {
        imgurl =imglink;
    }
    
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
       {
           petimgview.frame = CGRectMake(170 +imgcellxpos,64 +imgypos,newsize.width,newsize.height);

       }
    else
    {
        petimgview.frame = CGRectMake(408 +imgcellxpos,85 +imgypos,newsize.width,newsize.height);

    }
    
    petimgview.layer.cornerRadius = 9.0;
    petimgview.layer.masksToBounds = YES;

    
    NSInteger rank = [[object objectForKey:@"challengeRank"] integerValue];
    
    
    UIImageView *rankview = (UIImageView *)[cell viewWithTag:27];
    NSString *rankImg;
    if(rank ==1)
    {
        rankImg = [[NSBundle mainBundle] pathForResource:@"Rank1" ofType:@"png"];
    }
    if(rank ==2)
    {
        rankImg = [[NSBundle mainBundle] pathForResource:@"Rank2" ofType:@"png"];
    }
    if(rank ==3)
    {
        rankImg = [[NSBundle mainBundle] pathForResource:@"Rank3" ofType:@"png"];
    }
    if(rank ==101)
    {
        rankImg = [[NSBundle mainBundle] pathForResource:@"category-1" ofType:@"png"];
    }
    
    
    UIImage *rankimage = [UIImage imageWithContentsOfFile:rankImg];
    
    rankview.image = rankimage;
    
  rankview.frame = CGRectMake(petimgview.frame.origin.x+petimgview.frame.size.width -rankview.frame.size.width,petimgview.frame.origin.y-rankview.frame.size.height,rankview.frame.size.width,rankview.frame.size.height);
    
    
    UIImage *cellplaceholder = [UIImage imageWithContentsOfFile:@"imgloadingplaceholder.png"];
    
    NSString *imgtype = [object objectForKey:@"imgURType"];
    
    
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        // iPhone Classic
        if([imgtype isEqualToString:@"image/gif"])
        {
            imgurl = @"http://i.imgur.com/cwAB9XA.jpg";
        }
        
    }
    
    
    
    
    [petimgview setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder];
    
     //@Brian note--create a status to show the content expires in 10 days.
    
     UILabel *statusLabel= (UILabel *)[cell viewWithTag:1];
    
    NSDate *createdDate = object.createdAt;
       NSInteger daydiff = [self getDateDiffDays:createdDate];
    
    NSInteger daysleft = 10-daydiff;
    
    NSString *expire1 = @"Content Expires In ";
    NSString *expirenum = [NSString stringWithFormat:@"%i",daysleft];
    
    NSString *expiresend = @" Days";
    
    NSString *expirefullstring = [[expire1 stringByAppendingString:expirenum] stringByAppendingString:expiresend];
    
    statusLabel.text = expirefullstring;
    
    //set rgb color here
    //UIColor *statusfontcolor =
    UILabel *captionLabel= (UILabel *)[cell viewWithTag:2];
    captionLabel.text = [object objectForKey:@"Caption"];
    
    
    
    UILabel *picksLabel= (UILabel *)[cell viewWithTag:4];
   
    NSString *numpicksstring = [[object objectForKey:@"totalPicks"] stringValue];
    NSString *endstring = @" Votes";
    
    picksLabel.text = [numpicksstring stringByAppendingString:endstring];
    
    
    picksLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:8];
    
    
    UILabel *pickspctLabel= (UILabel *)[cell viewWithTag:6];
    
    
     pickspctLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:8];
    
    float pickspct = [[object objectForKey:@"pickPct"] floatValue];
   pickspct = pickspct *100;
    
    NSString *pickpct = [NSString stringWithFormat:@"%.1f",pickspct];
    
    pickspctLabel.text = pickpct;
    
    
    NSString *numlikesstring = [[object objectForKey:@"TotalLikes"] stringValue];
    NSString *endlikestring = @" Likes";
    
   
    UILabel *likesLabel= (UILabel *)[cell viewWithTag:8];
   likesLabel.text = [numlikesstring stringByAppendingString:endlikestring];
    likesLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:8];
   
    
    UIImage *ratingsImg= (UIImage *)[cell viewWithTag:9];
    float ratingavg = [[object objectForKey:@"avgRating"] floatValue];
    NSNumber *ratetosend = [NSNumber numberWithFloat:ratingavg];
    ratingsImg = [self getRatingImage:ratetosend];
    
    UILabel *ratingsLabel= (UILabel *)[cell viewWithTag:10];
    NSString *mystring = [[object objectForKey:@"TotalRatings"] stringValue];
    NSString *txtstring = [mystring stringByAppendingString:@" Ratings"];
    
    ratingsLabel.text =  txtstring;
    
     ratingsLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:8];
    
    UILabel *goldLabel= (UILabel *)[cell viewWithTag:12];
   
    NSInteger contentval= [[object objectForKey:@"contentValue"] integerValue];
    
    if([self.displayMode  isEqual:@"submits"])
    {
        contentval = floor(contentval/4);
    }
    
    
    goldLabel.text = [NSString stringWithFormat:@"%i",contentval];
     goldLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:8];
    MyPetCollectUIButton *mysharebtn = (MyPetCollectUIButton *)[cell viewWithTag:14];
    [mysharebtn addTarget:self action:@selector(shareclick:) forControlEvents:UIControlEventTouchUpInside];
    
  
    
    UILabel *sharebtnlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,mysharebtn.frame.size.width,mysharebtn.frame.size.height)];
    
    //sharebtnlabel.text = @"Share";
    sharebtnlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
    sharebtnlabel.textColor = [UIColor whiteColor];
   sharebtnlabel.textAlignment = NSTextAlignmentCenter;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
       {
           sharebtnlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:16];
            goldLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:16];
            ratingsLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:16];
            likesLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:16];
           pickspctLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:16];
            picksLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:16];
       }
       
       
    
    
    //[mysharebtn addSubview:sharebtnlabel];
    
        //if button hasnt been collected in last 12 hours, show.  If it has been collected from, show timer label with hours remaining instead.
    
    NSDate *lastcollect;
    if([self.displayMode  isEqual:@"submits"])
    {
        lastcollect = [object objectForKey:@"lastCollected"];
    }
    else
    {
       lastcollect= [object objectForKey:@"lastChampionCollected"];
    }
        
    NSInteger datediffint;
    if(lastcollect==nil)
    {
        datediffint = 14;
    }
    else
    {
   datediffint= [self getDateDiff:lastcollect];
        
    }
    NSLog(@"datediff %i",datediffint);

    if (datediffint <13)
    {
       
        MyPetCollectUIButton *mycollectbtn = (MyPetCollectUIButton *)[cell viewWithTag:15];
        
        UILabel *nocollectrightnowlabel = (UILabel *)[cell viewWithTag:22];
        
        mycollectbtn.alpha = 0;
        mycollectbtn.myindex = indexPath;
        
        NSString *cantcollect = @"Collect in ";
        NSString *hours = @" hours";
        NSString *hournum = [NSString stringWithFormat:@"%i",datediffint];
        
        NSString *nocollectstring = [cantcollect stringByAppendingString:hournum];
        NSString *fullnocollectstring = [nocollectstring stringByAppendingString:hours];
        
        nocollectrightnowlabel.text = fullnocollectstring;
        //nocollectrightnowlabel.textColor = [UIColor blackColor];
        
        nocollectrightnowlabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
        
        nocollectrightnowlabel.alpha = 1;
        
        //46 49 146 navy blue for browse title
        UIColor *mytbcolor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:146/255.0 alpha:1];
        nocollectrightnowlabel.textColor = mytbcolor;

        //NSLog(@"No collect now bubba");
        
    }
    else
    {
    
    MyPetCollectUIButton *mycollectbtn = (MyPetCollectUIButton *)[cell viewWithTag:15];
        
        UILabel *nocollectLabel = (UILabel *)[cell viewWithTag:22];
        //@Brian note--this is a quick & dirty solution, come back to it later...
       
        
        
        nocollectLabel.alpha=0;
        //[nocollectLabel removeFromSuperview];
        
        
        UILabel *collectbtnlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,mycollectbtn.frame.size.width,mycollectbtn.frame.size.height)];
        
        mycollectbtn.alpha =1;
         mycollectbtn.myindex = indexPath;
        
        //collectbtnlabel.text = @"Collect Influence";
        collectbtnlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
        collectbtnlabel.textAlignment = NSTextAlignmentCenter;
        collectbtnlabel.textColor = [UIColor whiteColor];
        collectbtnlabel.tag = 24;
        
        
        //[mycollectbtn addSubview:collectbtnlabel];
        
    [mycollectbtn addTarget:self action:@selector(collectclick:) forControlEvents:UIControlEventTouchUpInside];
   
        
    }
    return cell;
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

-(void) shareclick:(id)sender
{
    
    MyPetCollectUIButton *sharebtn = sender;
    NSLog(@"%d",sharebtn.myindex.row);//Here you know which button has pressed
    NSInteger btnindex = sharebtn.myindex.row;
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        //get selected content link.
        
        PFObject *thisobj = self.objects[btnindex];
        
        
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
    PFObject *thisobj = self.objects[sendIndex];
    
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
            //prog = [sharedData AddGoldXPScoreVote:20 withXP:0 withScore:0];
            //[self popupShareText];
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


-(void) collectclick : (id) sender{
    MyPetCollectUIButton *clicked = (MyPetCollectUIButton *) sender;
    NSLog(@"%d",clicked.myindex.row);//Here you know which button has pressed
    NSInteger btnidnex = clicked.myindex.row;
    
    PlayerData *sharedData = [PlayerData sharedData];
    
    NSInteger remainingcollects = [[sharedData collectsRemaining] integerValue];
    
    if(remainingcollects<=0)
    {
        //ui alert and return.
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Come Back Later", nil) message:NSLocalizedString(@"No Collects Remaining, Come Back Later!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    
    
    CGRect myrect = clicked.frame;
    CGPoint mypoint = CGPointMake(myrect.origin.x + (myrect.size.width / 2), myrect.origin.y + (myrect.size.height / 2));
    //play animation
    UIView *hostview = clicked.superview;
    
    GlobeParticleEmitter *gp = [[GlobeParticleEmitter alloc] initWithFrame:hostview.frame particlePosition:mypoint];
    [hostview addSubview:gp];
    
    [gp decayOverTime:1.0];
     //perform a collect action for this object and set the date you collected.
    
    //get the value of the content.
    
    PFObject *collectingObj = self.objects[btnidnex];
    NSInteger contentvalue = [[collectingObj objectForKey:@"contentValue"] floatValue];
    
    if([self.displayMode  isEqual:@"submits"])
    {
        contentvalue = floor(contentvalue/4);
    }
    //NSNumber *value = [NSNumber numberWithInteger:contentvalue];
    //add currency to user
    //cloud function to test if the user can buy
 
   
    BOOL addresult;
    if([self.displayMode  isEqual:@"submits"])
    {
         addresult = [sharedData addUserInfluence:contentvalue withType:1];
    }
    else
    {
         addresult = [sharedData addUserInfluence:contentvalue withType:2];
    }

   
    
    //@brian note--this is not getting the correct info...
    NSDate *curdate = [NSDate date];
    
    if (addresult==YES)
    {
        
        
        if([self.displayMode  isEqual:@"submits"])
        {
            [collectingObj setObject:curdate forKey:@"lastCollected"];
        }
        else
        {
            [collectingObj setObject:curdate forKey:@"lastChampionCollected"];
        }

        
   
                                        
    [collectingObj saveInBackground];
        
        
    //refresh top bar stats also and change the button to show collect in 12 hours.
        
     //remove button with bounce
        UIView *cell = clicked.superview;
        
       
        
        [cell PopButtonWithBounce:clicked];
        
        UILabel *nocolLabel = (UILabel *)[cell viewWithTag:22];
        
       nocolLabel.text = @"Collect in 12 hours";
        nocolLabel.alpha = 1;
        
        
         nocolLabel.textColor = [UIColor blackColor];
        nocolLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
        [self.mypqtdelegate ValueChange];
        
    }
    
    }

-(NSInteger) getDateDiff:(NSDate *) lastdate
{
    NSDate *datenow = [NSDate date];
    NSDate *dateB = lastdate;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:dateB
                                                 toDate:datenow
                                                options:0];
    
    NSLog(@"Difference in date components: %i/%i/%i", components.day, components.hour, components.second);
    NSInteger thedate;
    
    float hourssincecollect = components.day*24 + components.hour;
    
    
    if (hourssincecollect <12)
    {
        
        
        NSInteger timetocollect = 12;
        
        return timetocollect-hourssincecollect;
    }
    else
    {
    
    thedate = 25;
    return 25;
    }
}

-(NSInteger) getDateDiffDays:(NSDate *) lastdate
{
    NSDate *datenow = [NSDate date];
    NSDate *dateB = lastdate;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:dateB
                                                 toDate:datenow
                                                options:0];
    
    // NSLog(@"Difference in date components: %i/%i/%i", components.day, components.hour, components.second);
    NSInteger thedate;
    
    return components.day;
    
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


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Build a segue string based on the selected cell
   // NSString *segueString = [NSString stringWithFormat:@"MyPetDetails"];
    //Since contentArray is an array of strings, we can use it to build a unique
    //identifier for each segue.
    
    //Perform a segue.
    //[self performSegueWithIdentifier: @"MyPetDetails" sender:self];
    
    //bring up the content details page.
    
    FrontPageSelectionViewController *fps;
     fps = [self.storyboard instantiateViewControllerWithIdentifier:@"frontPageSelection"];
    
    fps.delegate = self;
    
    fps.selectedContent = self.objects[indexPath.row];
    
     [self.navigationController pushViewController:fps animated:YES];
}

- (void)FrontPageSelectionViewControllerBackToFrontPage:
(FrontPageSelectionViewController *)controller
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"MyPetDetails"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		MyPetDetailsViewController
        *MPViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *bob = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
      //  NSLog(@"selectedindex: %@", bob);        //set the selected pet from table here
        PFObject *selectPet = [self objectAtIndexPath:indexPath];
        
		MPViewController.delegate = self;
        MPViewController.selectedPet= selectPet;
        // add method to say destination petviewcontroller equals selected PFObject
	}
}
#pragma mark - BuyPetViewControllerDelegate Methods
- (void)MyPetDetailsViewControllerBackToMyPets:
(MyPetDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)refreshbutton:(id)sender {
    
    
}
@end
