//
// This is the template PFQueryTableViewController subclass file. Use it to customize your own subclass.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "BuyPetViewController.h"
#import "MarketplaceQueryTableviewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@implementation MarketplaceQueryTableViewController
//@synthesize MarketplaceTableView;
@synthesize querytouse;


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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
          self.tableView.rowHeight = 301;
      }
    
    
       self.tableView.backgroundColor = [UIColor clearColor];
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
    
    //add code to also include the pet ratings
    
            //need method to call to reload table
    return self.querytouse;
    
}



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"marketCell";
 
 PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
     
     cell.backgroundColor = [UIColor clearColor];
     
 
 // Configure the cell
 //cell.textLabel.text = [object objectForKey:self.textKey];
 //cell.imageView.file = [object objectForKey:self.imageKey];
     
     // Configure the cell...
     
  //   Pet *ptab = [self.pets objectAtIndex:indexPath.row];
     
     PFObject *funobjdata = object;
  
          //gets names and types from include key on query
     UILabel *captionLabel = (UILabel *)[cell viewWithTag:1];
     captionLabel.text = [funobjdata objectForKey:@"Caption"];
     
     UILabel *priceLabel = (UILabel *)[cell viewWithTag:2];
     NSNumber *pricenumber = [funobjdata objectForKey:@"Price"];
  priceLabel.text = [NSString stringWithFormat:@"%@", pricenumber];
     priceLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
     
     UILabel *ratingsLabel = (UILabel *)[cell viewWithTag:3];
     NSString *mystring = [[funobjdata objectForKey:@"TotalRatings"] stringValue];
     NSString *txtstring = [mystring stringByAppendingString:@" Ratings"];
     
     ratingsLabel.text =  txtstring;
     ratingsLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
     
     
     //get owner data
      UILabel *picksLabel = (UILabel *)[cell viewWithTag:4];
     
     NSString *numpicksstring = [[object objectForKey:@"totalPicks"] stringValue];
     NSString *endstring = @" Votes";
     
     picksLabel.text = [numpicksstring stringByAppendingString:endstring];
     
     
     picksLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
     
         UILabel *VoteDaysLeftLabel = (UILabel *)[cell viewWithTag:77];
     VoteDaysLeftLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:10];
     
     NSDate *crdate = funobjdata.createdAt;
     
     NSInteger dayssince = [self getDateDiffDays:crdate];
     
     NSInteger daysleft = 10-dayssince;
     
     NSString *daysremainingstring = [NSString stringWithFormat:@"%i",daysleft];
     
     NSString *str2 = @" Vote Days Left";
     
     VoteDaysLeftLabel.text = [daysremainingstring stringByAppendingString:str2];
     
     //46 49 146 navy blue for browse title
     UIColor *mytbcolor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:146/255.0 alpha:1];
         VoteDaysLeftLabel.textColor = mytbcolor;
     
     
     
     
      UILabel *influenceLabel = (UILabel *)[cell viewWithTag:5];
     influenceLabel.text = [[object objectForKey:@"contentValue"] stringValue];
     influenceLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
     
     UILabel *creatorlbl =(UILabel *)[cell viewWithTag:6];
     
     creatorlbl.font =[UIFont fontWithName:@"CooperBlackStd" size:8];
     
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
              creatorlbl.font =[UIFont fontWithName:@"CooperBlackStd" size:14];
             influenceLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:18];
             picksLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:18];
             VoteDaysLeftLabel.font = [UIFont fontWithName:@"CooperBlackStd" size:18];
             ratingsLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:18];
             priceLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:18];
        }
     
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
     
     UIImageView *petimgview = (UIImageView *)[cell viewWithTag:9];
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
     
     //briannote--check if not good for iPhone
     petimgview.frame = CGRectMake(408 +imgcellxpos,85 +imgypos,newsize.width,newsize.height);
     
     
     
     UIImage *cellplaceholder = [UIImage imageWithContentsOfFile:@"imgloadingplaceholder.png"];
     UIActivityIndicatorViewStyle activityStyle = UIActivityIndicatorViewStyleGray;
     
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
     
     
     [petimgview setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:cellplaceholder usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle ];
     petimgview.layer.cornerRadius = 9.0;
     petimgview.layer.masksToBounds = YES;
     PFObject *ownerobjdata = [object objectForKey:@"creator"];
    
     UILabel *ownerLabel =(UILabel *)[cell viewWithTag:8];
     ownerLabel.text  = [ownerobjdata objectForKey:@"displayName"];
    
     ownerLabel.font= [UIFont fontWithName:@"CooperBlackStd" size:8];
     
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      {
          ownerLabel.font =[UIFont fontWithName:@"CooperBlackStd" size:14];
      }
     //get rank then assign image
     
     NSInteger rank = [[object objectForKey:@"challengeRank"] integerValue];
     
     
     UIImageView *rankview = (UIImageView *)[cell viewWithTag:17];
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
     
     //CGRect petimgrect = petimgview.frame;
     
     
   rankview.frame = CGRectMake(petimgview.frame.origin.x+petimgview.frame.size.width -rankview.frame.size.width,petimgview.frame.origin.y-rankview.frame.size.height,rankview.frame.size.width,rankview.frame.size.height);
     
     UIImageView *profileimgview = (UIImageView *)[cell viewWithTag:7];
     
     PFFile *profpicfile = [ownerobjdata objectForKey:@"profilePictureSmall"];
     
     
     NSString *filesil = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
     UIImage *profplaceholder = [UIImage imageWithContentsOfFile:filesil];
     
    
     if(profpicfile==nil)
     {
         [profileimgview setImage:profplaceholder];
         
     }
     else
     {
          [profileimgview setImageWithURL:[NSURL URLWithString:profpicfile.url] placeholderImage:profplaceholder];
     }
   
     
     
         NSNumber *avgratingnum = [object objectForKey:@"avgRating"];
     
    //float avgRating = [avgratingnum floatValue];
     
     UIImageView *ratingimgview = (UIImageView *)[cell viewWithTag:93];
     //do logic to get ratings image
    
     
     ratingimgview.image = [self getRatingImage:avgratingnum];
     
     NSString *status = [object objectForKey:@"status"];
     
     if ([status isEqual:@"forSale"])
     {
         
         MyPetCollectUIButton *mybuybtn = (MyPetCollectUIButton *)[cell viewWithTag:10];
         
         UILabel *sharebtnlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,mybuybtn.frame.size.width,mybuybtn.frame.size.height)];
         
         //sharebtnlabel.text = @"Buy Now!";
         sharebtnlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         {
              sharebtnlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:16];
         }
         sharebtnlabel.textColor = [UIColor whiteColor];
         sharebtnlabel.textAlignment = NSTextAlignmentCenter;
         //[mybuybtn addSubview:sharebtnlabel];
         
         //@brian note--need to add the index of the buy button with a custom subclass...
         [mybuybtn addTarget:self action:@selector(buybuttonclick:) forControlEvents:UIControlEventTouchUpInside];
         mybuybtn.myindex = indexPath;
         mybuybtn.alpha =1;
         
          UILabel *boughtlabel = (UILabel *)[cell viewWithTag:11];
         boughtlabel.alpha=0;
         
     }
     else
     {
         UILabel *boughtlabel = (UILabel *)[cell viewWithTag:11];
         boughtlabel.text = @"Already Bought";
         boughtlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         {
            boughtlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:16];
         }
         boughtlabel.alpha=1;
         MyPetCollectUIButton *mybuybtn = (MyPetCollectUIButton *)[cell viewWithTag:10];
         mybuybtn.alpha=0;
         
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

-(void) buybuttonclick:(id)sender
{
    MyPetCollectUIButton *clicked = sender;
    
    //buy
    //add commands to buy the pet and change backend database via parse
    PFUser *user = [PFUser currentUser];
    
    NSString *useridstring = user.objectId;
    PFObject *fundataobj = self.objects[clicked.myindex.row];
    
    
   // PFObject *petdataobj = selectedPet;
    NSString *idstring = fundataobj.objectId;
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Processing";
    [HUD show:YES];
    
        HUD.progress = (float)25/100;
    //cloud function to test if the user can buy
    [PFCloud callFunctionInBackground:@"buyObjectFromCreatorForInfluence"
                       withParameters:@{@"user":useridstring,@"objID":idstring}
                                block:^(NSString *success, NSError *error) {
                                    if (!error) {
                                        // ratings is 4.5
                                        //NSString *myString = success;
                                        //NSLog(myString);
                                      
                                        //update the top bar to show the new currency.
                                       
                                         PlayerData *sharedData = [PlayerData sharedData];
                                    
                                        NSInteger usergold =  [sharedData.userGold integerValue];
                                        
                                        NSInteger price = [[fundataobj objectForKey:@"Price"] integerValue];
                                        
                                        NSInteger usernewgold = usergold-price;
                                        
                                        sharedData.userGold = [NSNumber numberWithInt:usernewgold];
                                        
                                        
                                        [self.mqdelegate updateTopNums];
                                        
                                        [HUD hide:YES];
                                        //play an animation to show you bought it and draw over the button for this content.
                                        //remove button with bounce
                                        UIView *cell = clicked.superview;
                                        
                                        [cell PopButtonWithBounce:clicked];
                                        
                                        UILabel *boughtlabel = (UILabel *)[cell viewWithTag:11];
                                        boughtlabel.text = @"You Bought This!";
                                        //46 49 146 navy blue for browse title
                                        UIColor *mytbcolor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:146/255.0 alpha:1];
                                        boughtlabel.textColor = mytbcolor;
                                        
                                         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                                         {
                                           boughtlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:10];
                                         }
                                        else
                                        {
                                            boughtlabel.font= [UIFont fontWithName:@"CooperBlackStd" size:18];
                                        }
                                        
                                        boughtlabel.alpha=1;
                                        
                                        
                                    }
                                    else
                                    {
                                         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Something Went Wrong!", nil) message:NSLocalizedString(@"Something went wrong, try purchasing a different piece of content", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                                    }
                                }];
    
    
    
    
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
   // NSString *segueString = [NSString stringWithFormat:@"BuyPetDetails"];
    //Since contentArray is an array of strings, we can use it to build a unique
    //identifier for each segue.
    
    //Perform a segue.
  //[self performSegueWithIdentifier: @"BuyPetDetails" sender:self];
    
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
	if ([segue.identifier isEqualToString:@"BuyPetDetails"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		BuyPetViewController
        *BPViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
    
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *bob = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
        NSLog(@"selectedindex: %@", bob);        //set the selected pet from table here
        PFObject *selectPet = [self objectAtIndexPath:indexPath];
        
		BPViewController.delegate = self;
        BPViewController.selectedPet= selectPet;
        // add method to say destination petviewcontroller equals selected PFObject
	}
}
#pragma mark - BuyPetViewControllerDelegate Methods
- (void)BuyPetViewControllerBackToMarketplace:
(BuyPetViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)BuyPetViewViewController:
(BuyPetViewController *)controller BuyPet:(PFObject *)PetBought
{
    
};




- (IBAction)refreshbutton:(id)sender {
}
@end