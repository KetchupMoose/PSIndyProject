//
//  GoldStoreViewController.m
//  funnyBusiness
//
//  Created by Macbook on 2013-11-18.
//  Copyright (c) 2013 bricorp. All rights reserved.
//

#import "GoldStoreViewController.h"
#import "PickIAPHelper.h"
#import <StoreKit/StoreKit.h>



@implementation GoldStoreViewController
NSArray *_products;
@synthesize goldstoredelegate;
@synthesize golddiamondswitch;
// Add new instance variable to class extension
NSNumberFormatter * _priceFormatter;
NSArray *goldvaluesarray;
NSArray *diamondvaluesarray;
NSInteger goldMode =1;
MBProgressHUD *HUD;


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
    
    NSLog(@"it loaded");
    
    self.golddiamondswitch.frame = CGRectMake(64,48,236,29);
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"storetop-bar" ofType:@"png"];
    UIImage *segmentimage = [UIImage imageWithContentsOfFile:fileName];
    segmentimage = [self imageWithImage:segmentimage scaledToSize:CGSizeMake(236,29)];
    
    [self.golddiamondswitch setBackgroundImage:segmentimage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    TopBarViewController *tpvc;
    
    tpvc=[self.storyboard instantiateViewControllerWithIdentifier:@"topbar"];
    
    [self addChildViewController:tpvc];
    
    tpvc.topbardelegate = self;
    
    
    [self.thetopbar addSubview:tpvc.view];
    
    tpvc.view.frame = self.thetopbar.bounds;

    NSString *bgfileName = [[NSBundle mainBundle] pathForResource:@"blue-background" ofType:@"png"];
    UIImage *background =[UIImage imageWithContentsOfFile:bgfileName];
    
    UIImage *myb = [self imageWithImage:background scaledToSize:self.view.frame.size];
    
    // Add to end of viewDidLoad
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:myb]];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Mining Gold..";
    [HUD show:YES];
    
    }



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    
   // [self setPricesAndValues];
}

-(void)viewDidAppear:(BOOL) animated{
    [self getIAPData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            //do code to give a value in gold depending on what the user actually bought.
            NSLog(@"the purchase gave the notification");
            NSNumber *curtogive = [NSNumber numberWithInteger:500];
            BOOL serverworks = [self giveCurrency:curtogive];
            
            
            *stop = YES;
        }
    }];
    
}
-(BOOL) giveCurrency:(NSNumber *) currency
{
    PFUser *user = [PFUser currentUser];
    [PFCloud callFunctionInBackground:@"addCurrency"
                       withParameters:@{@"user":user.objectId,@"currencyAdd":currency}
                                block:^(NSString *success, NSError *error) {
                                    if (!error) {
                                        // change btn status to collected
                                        NSLog(@"User was given currency");
                                        
                                        //@Brian Note--need to make sure the app updates with the new currency
                                        
                                        //show an alert saying thanks for your purchase, you now have this much more gold!
                                         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thank You!", nil) message:NSLocalizedString(@"Your gold or diamonds have been added on the top bar!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                                        
                                        
                                    }
                                }];
}


-(void)setPricesAndValues
{
    NSLog(@"this ran");
    
    //get values from parse for each slot.
      PFQuery *query = [PFQuery queryWithClassName:@"funPhotoGoldValues"];
    [query whereKey:@"saleType" equalTo:@"normal"];
    PFObject *valuesobj = [query getFirstObject];
    
   goldvaluesarray = [valuesobj objectForKey:@"goldValues"];
    
    diamondvaluesarray = [valuesobj objectForKey:@"diamondValues"];
    
    [self setLabelValues];
    
    //get prices from IAP data
    
}

-(void) setLabelValues
{
    if (goldMode==1)
    {
        //set gold values and set gold prices
        //9.99
        NSString *goldstring = [goldvaluesarray[2] stringValue];
        self.value1text.text = [goldstring stringByAppendingString:@" Gold"];
        
        //4.99
        goldstring = [goldvaluesarray[1] stringValue];
        self.value2text.text = [goldstring stringByAppendingString:@" Gold"];
        
        //0.99
        goldstring = [goldvaluesarray[0] stringValue];
        self.value3text.text = [goldstring stringByAppendingString:@" Gold"];
        
        //99.99
        goldstring = [goldvaluesarray[5] stringValue];
        self.value4text.text = [goldstring stringByAppendingString:@" Gold"];
        
        //24.99
        goldstring = [goldvaluesarray[3] stringValue];
        self.value5text.text = [goldstring stringByAppendingString:@" Gold"];
        
        //49.99
        goldstring = [goldvaluesarray[4] stringValue];
        self.value6text.text = [goldstring stringByAppendingString:@" Gold"];
        
        //set prices
        SKProduct * product = (SKProduct *) _products[1];
        [_priceFormatter setLocale:product.priceLocale];
        self.price1text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[0];
        [_priceFormatter setLocale:product.priceLocale];
        self.price2text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[2];
        [_priceFormatter setLocale:product.priceLocale];
        self.price3text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[5];
        [_priceFormatter setLocale:product.priceLocale];
        self.price4text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[3];
        [_priceFormatter setLocale:product.priceLocale];
        self.price5text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[4];
        [_priceFormatter setLocale:product.priceLocale];
        self.price6text.text=[_priceFormatter stringFromNumber:product.price];
       
        
    }
    else
    {
        //set diamond values and set gold prices
        
        //9.99
        NSString *diamondstring = [diamondvaluesarray[3] stringValue];
        self.value1text.text = [diamondstring stringByAppendingString:@" Diamonds"];
        
        //4.99
        diamondstring = [diamondvaluesarray[1] stringValue];
        self.value2text.text = [diamondstring stringByAppendingString:@" Diamonds"];
        
        //0.99
        diamondstring = [diamondvaluesarray[0] stringValue];
        self.value3text.text = [diamondstring stringByAppendingString:@" Diamonds"];
        
        //99.99
        diamondstring = [diamondvaluesarray[5] stringValue];
        self.value4text.text = [diamondstring stringByAppendingString:@" Diamonds"];
        
        //24.99
        diamondstring = [diamondvaluesarray[3] stringValue];
        self.value5text.text = [diamondstring stringByAppendingString:@" Diamonds"];
        
        //49.99
        diamondstring = [diamondvaluesarray[4] stringValue];
        self.value6text.text = [diamondstring stringByAppendingString:@" Diamonds"];
        
        //set prices diamonds.  diamonds start at 6 on array
        SKProduct * product = (SKProduct *) _products[9];
        [_priceFormatter setLocale:product.priceLocale];
        self.price1text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[7];
        [_priceFormatter setLocale:product.priceLocale];
        self.price2text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[11];
        [_priceFormatter setLocale:product.priceLocale];
        self.price3text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[10];
        [_priceFormatter setLocale:product.priceLocale];
        self.price4text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[6];
        [_priceFormatter setLocale:product.priceLocale];
        self.price5text.text=[_priceFormatter stringFromNumber:product.price];
        
        product = (SKProduct *) _products[8];
        [_priceFormatter setLocale:product.priceLocale];
        self.price6text.text=[_priceFormatter stringFromNumber:product.price];
        
        
    }
}

-(IBAction) PressPrice1:(id) sender
{
    if (goldMode==1)
    {
        SKProduct *product = _products[1];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    else
    {
        SKProduct *product = _products[9];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    
   
}

-(IBAction) PressPrice2:(id) sender
{
    if (goldMode==1)
    {
        SKProduct *product = _products[0];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    else
    {
        SKProduct *product = _products[7];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    
}
-(IBAction) PressPrice3:(id) sender
{
    if (goldMode==1)
    {
        SKProduct *product = _products[2];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    else
    {
        SKProduct *product = _products[11];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    
}
-(IBAction) PressPrice4:(id) sender
{
    if (goldMode==1)
    {
        SKProduct *product = _products[5];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    else
    {
        SKProduct *product = _products[10];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    
}
-(IBAction) PressPrice5:(id) sender
{
    if (goldMode==1)
    {
        SKProduct *product = _products[3];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    else
    {
        SKProduct *product = _products[6];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    
}
-(IBAction) PressPrice6:(id) sender
{
    if (goldMode==1)
    {
        SKProduct *product = _products[4];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    else
    {
        SKProduct *product = _products[8];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        [[PickIAPHelper sharedInstance] buyProduct:product];
    }
    
}

- (void)getIAPData {
    _products = nil;
   
    [[PickIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self setPricesAndValues];
            
            [HUD hide:YES];
            
        }
        else
        {
            NSLog(@"failure on get iap data");
            
        }
       
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) BackToBuyStuffScreen:(id) sender
{
    [self.goldstoredelegate BackToBuyStuff:self];
    
}

-(IBAction) PressSwitchGoldDiamond:(id) sender
{
    NSInteger barnum ;
    
    barnum= self.golddiamondswitch.selectedSegmentIndex;
    NSLog(@"retrieved bar number: %i", barnum);
    
    if (goldMode==1)
    {
        goldMode=0;
    }
    else
    {
        goldMode=1;
    }
    
    if(barnum==0)
    {
        //do gold layout.
        
        //get gold image from file
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"storeGold-icon" ofType:@"png"];
        UIImage *goldicon = [UIImage imageWithContentsOfFile:fileName];
        self.priceicon1.image = goldicon;
        self.priceicon4.image = goldicon;
        
        
        
        
    }
    else
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"storediamond-icon" ofType:@"png"];
        UIImage *diamondicon = [UIImage imageWithContentsOfFile:fileName];
        self.priceicon1.image = diamondicon;
        self.priceicon4.image = diamondicon;
        
        
           }
    
    [self setLabelValues];
    
    
}

-(IBAction) PressPriceFree:(id) sender
{
    //show ad colony ad.
    
    AppDelegate *myad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    MainLoadTabBarController *mvc = (MainLoadTabBarController *)self.tabBarController;
    
    [mvc.theAudio stop];
    
    [AdColony playVideoAdForZone:@"vzea23b03bdc304d0ea9" withDelegate:myad withV4VCPrePopup:YES
                andV4VCPostPopup:YES];
}


-(void) onAdColonyV4VCReward:(BOOL)success currencyName:(NSString*)currencyName currencyAmount:(int)amount inZone:(NSString*)zoneID {
	
    NSLog(@"AdColony zone %@ reward %i %i %@", zoneID, success, amount, currencyName);
	
	if (success) {
        PlayerData *sharedData = [PlayerData sharedData];
        
        NSInteger coinBalance = [sharedData.userGold integerValue];
        
        NSInteger diamondBalance = [sharedData.userGems integerValue];
        
        coinBalance = coinBalance + (amount*20);
        
        diamondBalance = diamondBalance +amount;
        
        sharedData.userGold = [NSNumber numberWithInt:coinBalance];
        sharedData.userGems = [NSNumber numberWithInt:diamondBalance];
        
        PFUser *user = [PFUser currentUser];
        
        [user setObject:sharedData.userGold forKey:@"Currency"];
        [user setObject:sharedData.userGems forKey:@"Gems"];
		
        [user saveInBackground];
        
        MainLoadTabBarController *mvc = (MainLoadTabBarController *)self.tabBarController;
        [mvc.theAudio prepareToPlay];
        [mvc.theAudio play];
    }
}

- (void) onAdColonyAdStartedInZone:(NSString *)zoneID
{
    MainLoadTabBarController *mvc = (MainLoadTabBarController *)self.tabBarController;
    [mvc.theAudio stop];
    
    
}

- (void) onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID
{
    MainLoadTabBarController *mvc = (MainLoadTabBarController *)self.tabBarController;
    [mvc.theAudio prepareToPlay];
    [mvc.theAudio play];
    
    
    //give gold rewards
    
}



@end
