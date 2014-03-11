//
//  BadgesViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-11.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "BadgesViewController.h"
#import "TopBarViewController.h"
#import "BadgeCollectionViewCell.h"


//@Brian notes: general outline of achievement system

//step 1: client needs to see they unlocked an achievement
//each action that can trigger an achievement should check if the client has qualified
//these actions check the plist.  If the user already has it on their plist, nothing happens.
//if not, it saves to the user plist and shows them the achievement popup.  it then stores on the server they got the achievement.
//some achievements can be triggered on the server, such as getting 5 elite pieces of content or getting 5 photos of a content set.  These can update the next player logs in when we sync with the server data.

//needs:generate a plist of achievement data
//


@interface BadgesViewController ()

@end

@implementation BadgesViewController

@synthesize bvcdelegate;
@synthesize badgeview;
@synthesize badgepick;
@synthesize mytopbar;



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
    
    //set the top bar;
    //code to add top bar to container
    
    TopBarViewController *tb;
    tb=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tb];
    
    [self.mytopbar addSubview:tb.view];
    
    tb.view.frame = self.mytopbar.bounds;

    self.badgeview.delegate = self;
    self.badgeview.dataSource = self;
    
    
    [self.badgeview registerNib:[UINib nibWithNibName:@"BadgeCollectionViewCell" bundle:nil]
 forCellWithReuseIdentifier:@"BadgeCell"];
    
    
    
    [self.badgeview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupgestures
{
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];
    
    
    
    
}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
   }

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    // do moving
    NSLog(@"swiped left");
    
    [self.bvcdelegate dismissBVC:self];
    //dismiss view controller
    
    
    
}


-(IBAction)badgetypechoice:(id)sender
{
    //you chose a badge!
    
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
   // NSString *searchTerm = self.searches[section];
    //return [self.searchResults[searchTerm] count];
    return 20;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
    
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BadgeCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"BadgeCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.cellPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"81to85" ofType:@"png"];
    cell.cellPhoto.image = [UIImage imageWithContentsOfFile:fileName];
    
    
    
    
    cell.cellLabel.text = @"Badge Text Here";
    
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
    //self.searchResults[searchTerm][indexPath.row];
    // 2
    //CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
   // retval.height += 35; retval.width += 35;
    return CGSizeMake(90,90);
    
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
   
}


@end
