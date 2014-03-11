//
//  MCCollectionViewCell.h
//  funnyBusiness
//
//  Created by Macbook on 2013-10-16.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "PSCollectionViewCell.h"
#import <Parse/Parse.h>

@interface MCCollectionViewCell : PSCollectionViewCell

	@property (nonatomic,strong) IBOutlet UILabel *cellText;
    @property (nonatomic,strong) IBOutlet UIImageView *cellImage;

@end
