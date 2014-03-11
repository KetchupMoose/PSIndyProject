//
//  TwoTableViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-16.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionview.h"
#import <parse/parse.h>
#import "FrontPageSelectionViewController.h"

//whatever, let's change twotableviewcontroller to a PSCollectionView

@interface TwoTableCollectionView : PSCollectionView <FrontPageSelectionViewControllerDelegate>

//this is the function to get it to query data and load
- (void)queryforData;

@property (strong,nonatomic) NSMutableArray *contentObjectsArray;
@property (strong,nonatomic) PFQuery *querytouse;




@end
