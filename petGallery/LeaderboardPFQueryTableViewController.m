//
//  LeaderboardPFQueryTableViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "LeaderboardPFQueryTableViewController.h"

@interface LeaderboardPFQueryTableViewController ()

@end

@implementation LeaderboardPFQueryTableViewController
@synthesize querytouse;
@synthesize leaderMode;


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
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     {
           self.tableView.rowHeight = 128;
     }
  
    
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    //add code to also include the pet ratings
    
    //need method to call to reload table
    return self.querytouse;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"leaderboardCell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    //cell.textLabel.text = [object objectForKey:self.textKey];
    //cell.imageView.file = [object objectForKey:self.imageKey];
    
    // Configure the cell...
    
    //   Pet *ptab = [self.pets objectAtIndex:indexPath.row];
    
    PFObject *leaderboardobjdata = object;
        //gets names and types from include key on query
    UILabel *rankLabel = (UILabel *)[cell viewWithTag:1];
    
    NSInteger rank = indexPath.row;
    
    NSInteger rank1 = rank+1;
    
    rankLabel.text = [NSString stringWithFormat:@"%i", rank1];
    
    UIImageView *profpic = (UIImageView *)[cell viewWithTag:2];
 
    NSInteger mode = [leaderMode integerValue];
    
    
    if(mode==1)
    {
    PFObject *userobj = [leaderboardobjdata objectForKey:@"Player"];
    
    PFFile *profpicfile = [userobj objectForKey:@"profilePictureSmall"];
       
    
        NSString *filesil = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
        UIImage *profplaceholder = [UIImage imageWithContentsOfFile:filesil];
        
        
        if(profpicfile==nil)
        {
            [profpic setImage:profplaceholder];
            
        }
        else
        {
            [profpic setImageWithURL:[NSURL URLWithString:profpicfile.url] placeholderImage:profplaceholder];
        }

     
        //get player data
    UILabel *usernameLabel = (UILabel *)[cell viewWithTag:3];
       usernameLabel.text = [userobj objectForKey:@"displayName"];
    
    UILabel *scoreLabel =(UILabel *)[cell viewWithTag:4];
    scoreLabel.text = [[leaderboardobjdata objectForKey:@"Score"] stringValue];
    }
    
        if(mode==2)
    {
       
        
        PFFile *profpicfile = [leaderboardobjdata objectForKey:@"profilePictureSmall"];
        NSString *filesil = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
        UIImage *profplaceholder = [UIImage imageWithContentsOfFile:filesil];
        
        
        if(profpicfile==nil)
        {
            [profpic setImage:profplaceholder];
            
        }
        else
        {
            [profpic setImageWithURL:[NSURL URLWithString:profpicfile.url] placeholderImage:profplaceholder];
        }

        //get player data
        UILabel *usernameLabel = (UILabel *)[cell viewWithTag:3];
        usernameLabel.text = [leaderboardobjdata objectForKey:@"displayName"];
        
        UILabel *scoreLabel =(UILabel *)[cell viewWithTag:4];
        scoreLabel.text = [[leaderboardobjdata objectForKey:@"lifetimeSubmitInfluence"] stringValue];
    }
    
    if(mode==3)
    {
        
        
        PFFile *profpicfile = [leaderboardobjdata objectForKey:@"profilePictureSmall"];
        NSString *filesil = [[NSBundle mainBundle] pathForResource:@"profile-sillhouette" ofType:@"png"];
        UIImage *profplaceholder = [UIImage imageWithContentsOfFile:filesil];
        
        
        if(profpicfile==nil)
        {
            [profpic setImage:profplaceholder];
            
        }
        else
        {
            [profpic setImageWithURL:[NSURL URLWithString:profpicfile.url] placeholderImage:profplaceholder];
        }

        //get player data
        UILabel *usernameLabel = (UILabel *)[cell viewWithTag:3];
        usernameLabel.text = [leaderboardobjdata objectForKey:@"displayName"];
        
        UILabel *scoreLabel =(UILabel *)[cell viewWithTag:4];
        scoreLabel.text = [[leaderboardobjdata objectForKey:@"lifetimeChampionInfluence"] stringValue];
    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
