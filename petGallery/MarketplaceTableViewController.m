//
//  MarketplaceTableViewController.m
//  petGallery
//
//  Created by mac on 6/25/13.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "MarketplaceTableViewController.h"
#import <Parse/Parse.h>
#import "Pet.h"
@interface MarketplaceTableViewController ()

@end

@implementation MarketplaceTableViewController

@synthesize pets;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //b.A. note it is possible to refresh immediately upon loading
    
   // [self refreshmarket:(self)];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return pets.count;
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"marketCell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Pet *ptab = [self.pets objectAtIndex:indexPath.row];
	UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
	nameLabel.text = ptab.petNamec;
	UILabel *gameLabel = (UILabel *)[cell viewWithTag:2];
	gameLabel.text = ptab.petTypec;
	
    PFImageView *petimgview = (PFImageView *)[cell viewWithTag:101];
    petimgview.file = ptab.petMarketThumbc;
    
  [petimgview loadInBackground];
    
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)refreshmarket:(id)sender {
    
      PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"petPhoto"];
    
    //later change this to be not equal to and boolean flagged for sale.
    [query whereKey:@"creator" notEqualTo:user];
    [query whereKey:@"status" equalTo:@"forSale"];
    [query includeKey:@"petObject"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            
            
            [pets removeAllObjects];
            
            //setup a pet object to add and set its properties from parse object
         
            
            for (PFObject *petphotodata in objects)
            {
                   Pet *padd = [[Pet alloc] init];
              PFObject *petobjdata = [petphotodata objectForKey:@"petObject"];
                
                padd.petNamec = [petobjdata objectForKey:@"Name"];
                padd.petTypec = [petobjdata objectForKey:@"Type"];
               
                
                
                PFFile *theImage = [petphotodata objectForKey:@"imageFile"];
                 NSLog(@"retrieved image: %@", theImage.name);
                padd.petMarketThumbc = theImage;
                
                [pets addObject:padd];
                
            }
           
           //reloads the table view
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    //need method to call to reload table
    
}
@end
