//
//  FrontPagePFQueryTableViewController.m
//  petGallery
//
//  Created by mac on 7/25/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "FrontPagePFQueryTableViewController.h"
#import "FrontPageSelectionViewcOntroller.h"



@implementation FrontPagePFQueryTableViewController
@synthesize frontPageQuery;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable {
    
    return frontPageQuery;
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"frontPageCell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    //cell.textLabel.text = [object objectForKey:self.textKey];
    //cell.imageView.file = [object objectForKey:self.imageKey];
    
    // Configure the cell...
    
    //   Pet *ptab = [self.pets objectAtIndex:indexPath.row];
    

    
    
    
    
  
    
    //get owner data
    UILabel *ownerLabel = (UILabel *)[cell viewWithTag:3];
    PFObject *ownerobjdata = [object objectForKey:@"creator"];
    
    ownerLabel.text  = [ownerobjdata objectForKey:@"username"];
    
    
    //take the image data from the uiimage
    PFFile *theImage = [object objectForKey:@"imageFile"];
    NSLog(@"retrieved imageblah: %@", theImage.name);
    
    PFImageView *petimgview = (PFImageView *)[cell viewWithTag:2];
    petimgview.file = theImage;
    [petimgview loadInBackground];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Build a segue string based on the selected cell
    //NSString *segueString = [NSString stringWithFormat:@"FrontPageDetailViewSegue"];
    //Since contentArray is an array of strings, we can use it to build a unique
    //identifier for each segue.
    
    //Perform a segue.
    [self performSegueWithIdentifier: @"FrontPageDetailViewSegue" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"FrontPageDetailViewSegue"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		FrontPageSelectionViewController
        *FPSViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *bob = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
        NSLog(@"selectedindex: %@", bob);        //set the selected pet from table here
        PFObject *selectedContent = [self objectAtIndexPath:indexPath];
        
        NSLog(@"self%@",self);
        
		FPSViewController.delegate = self;
        FPSViewController.selectedContent= selectedContent;
        // add method to say destination petviewcontroller equals selected PFObject
	}
}

- (void)FrontPageSelectionViewControllerBackToFrontPage:
(FrontPageSelectionViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
