//
//  ContentSelectReportInappropriateViewController.h
//  funnyBusiness
//
//  Created by Macbook on 2013-11-30.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface ContentSelectReportInappropriateViewController : UIViewController<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UILabel *reportLabel;

@property (weak, nonatomic) IBOutlet UILabel *reportLabel2;

@property (weak, nonatomic) IBOutlet UIButton *reportbtn;

- (IBAction)reportContent:(id)sender;

@property (nonatomic,strong) PFObject *selectedcontentobj;

@end
