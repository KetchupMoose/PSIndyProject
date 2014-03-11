//
//  TwoTableViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-10-16.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "TwoTableCollectionView.h"
#import "PSCollectionView.h"
#import "MCCollectionViewCell.h"


@interface TwoTableCollectionView ()

@end

@implementation TwoTableCollectionView
NSArray *arryData;
NSInteger selectionIndex;
@synthesize querytouse;


//brian note: trying to change to a setup where the twotableviewcontroller does all the querying when I change the tab..
-(void) queryforData
{
    PFQuery *contentQuery = querytouse;
    
    [contentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            //set the array
            
            [self.contentObjectsArray removeAllObjects];
            
            PFObject *bl;
            
            //try to do the proper method for adding the objects to the array.
            
            for (bl in objects)
                
            {
                [self.contentObjectsArray addObject:(bl)];
            
            }
            //self.contentObjectsArray = objects;
            
            
            //need method to call to reload table
            //[self reloadData:(self)];
            
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    NSLog(@"thismanysubviews %i" , self.subviews.count);
    
    
    
    
    NSLog(@"didre-query");
}


- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [MCCollectionViewCell class];
}

//PSCollectionView Data Source Required Methods

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    
    //change this to a property I can set via the results of the query.
    
    return self.contentObjectsArray.count;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"I ttvc appeared!!");
    
    
    
    
    //[self setContentOffset:CGPointMake(0,0) animated:YES];
}




- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
    MCCollectionViewCell *cell = (MCCollectionViewCell *)[collectionView dequeueReusableViewForClass:[MCCollectionViewCell class]];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MCCollectionViewCell" owner:self options:nil];
                
                cell = (MCCollectionViewCell *)[nib objectAtIndex:0];
                
                NSLog(@"loading this cell: %i", index);
                        }
    
    NSOperationQueue *imageQueue = [[NSOperationQueue alloc] init];
    [imageQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        int r = arc4random() % 3;
        NSString *imageName = [NSString stringWithFormat:@"image%d", r];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"]];
        
        [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
            
            PFObject *thisobj = [self.contentObjectsArray objectAtIndex:index];
            
            
            cell.cellText.text = [thisobj objectForKey:@"Caption"];
           // cell.cellImage.file = [thisobj objectForKey:@"imageFile"];
            
           // [cell.cellImage loadInBackground];
            
         
        }]];
    }]];
    
    
     //NSLog(@"got it: %i", index);
    
                    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    return 290.0;
}

//PScollectionview optional delegate methods

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{

    //invoke something with the selected cell.
      NSLog(@"selectedcellindex: %i", index);
    
    selectionIndex = index;
    
    
    //get the PF object selected and invoke a method to segue or popup another form from this cell..
    //Perform a segue.
   
    //[self performSegueWithIdentifier: @"twoPagetoDetailsSegue" sender:self];
    
    
};

//segue methods to show another view controller when a cell is selected.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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


- (void)FrontPageSelectionViewControllerBackToFrontPage:
(FrontPageSelectionViewController *)controller
{
	//[self dismissViewControllerAnimated:YES completion:nil];
}




@end
