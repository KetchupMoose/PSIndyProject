//
//  MarketplaceQueryUITableViewCell.m
//  funnyBusiness
//
//  Created by Macbook on 2013-12-09.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "MarketplaceQueryUITableViewCell.h"

@implementation MarketplaceQueryUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect tmpFrame = self.frame;
        
          if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
              
          {
              tmpFrame.origin.x = 5;
              tmpFrame.size.width = 310;
              tmpFrame.size.height = 299;
          }
      
        
        self.frame = tmpFrame;
        
    }
    return self;
}

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    // Do something
    
    CGRect tmpFrame = self.frame;
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
         tmpFrame.origin.x = 5;
         tmpFrame.size.width = 310;
         tmpFrame.size.height = 299;
     }
  
    
    self.frame = tmpFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect tmpFrame = self.frame;
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
          tmpFrame.origin.x = 5;
          tmpFrame.size.width = 310;
          tmpFrame.size.height = 299;
      }

    
    self.frame = tmpFrame;
    
}

@end
