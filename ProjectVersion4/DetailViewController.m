//
//  DetailViewController.m
//  ProjectVersion4
//
//  Created by user34 on 2017/5/24.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import "CoreDataHelper.h"
@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;


@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeTelephone;
@property (weak, nonatomic) IBOutlet UILabel *storeAddress;
@property (weak, nonatomic) IBOutlet UIImageView *store2Map;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    switch (self.type) {
        case 1:
            self.typeImageView.image = [UIImage imageNamed:@"003-plate-fork-and-knife"];
            break;
        case 2:
            self.typeImageView.image = [UIImage imageNamed:@"002-coffee-cup"];
            break;
        case 3:
            self.typeImageView.image = [UIImage imageNamed:@"001-bread"];
            break;
        default:
            self.typeImageView.image = [UIImage imageNamed:@"003-plate-fork-and-knife"];
            break;
    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setDetailInitView];
    
}


-(void) setDetailInitView{
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back2NearFoodTableView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self action:@selector(addToFavorite)];
    if (!self.storeInfo.isFavorite) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"addToFavorite", @"");
    }else{
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"deleteFromFavorite", @"");
    }
    
    self.storeName.text = self.storeInfo.name;
    self.storeTelephone.text = self.storeInfo.phoneNumber;
    self.storeAddress.lineBreakMode = NSLineBreakByWordWrapping;
    //self.storeAddress.numberOfLines = 0;
    self.storeAddress.text = self.storeInfo.address;
    self.store2Map.image = [UIImage imageNamed:@"loading"];
    [self getIconImage];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(connectToGoogleMap)];
    recognizer.requiresExclusiveTouchType = 1;
    [self.store2Map setUserInteractionEnabled:YES];
    [self.store2Map addGestureRecognizer:recognizer];
    
    self.nameLabel.text = NSLocalizedString(@"name", @"");
    self.telephoneLabel.text = NSLocalizedString(@"telephone", @"");
    self.addressLabel.text = NSLocalizedString(@"address", @"");
    self.connectLabel.text = NSLocalizedString(@"connect", @"");
}

-(void)addToFavorite{
    self.storeInfo.isFavorite = !self.storeInfo.isFavorite;
    if (!self.storeInfo.isFavorite) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"addToFavorite", @"");
    }else{
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"deleteFromFavorite", @"");
    }
    [self isAddingToFavorite:self.storeInfo.isFavorite];
}

-(void)isAddingToFavorite:(Boolean)addToFavorite{

    Boolean isRepeat = false;
    StoreInfo *temp;
    for (StoreInfo *test in self.favoriteData) {
        if ([test.name isEqualToString:self.storeInfo.name]) {
            isRepeat = true;
            temp = test;
        }
    }


    if (addToFavorite && (!isRepeat)) {
        NSManagedObjectContext *contex = [CoreDataHelper sharedInstance].managedObjectContext;
        temp = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:contex];
        [temp copyFromAnotherStoreDetail:self.storeInfo];
        [self.favoriteData insertObject:temp atIndex:0];
        [contex save:nil];
        
    }
    if((!addToFavorite) && isRepeat){
        NSManagedObjectContext *contex = [CoreDataHelper sharedInstance].managedObjectContext;
        //temp;
        //[temp copyFromAnotherStoreDetail:self.storeInfo];
        [contex deleteObject:temp];
        [contex save:nil];
        [self.favoriteData removeObject:temp];
        
    }

}

-(void)connectToGoogleMap{
    // Decide Source MapItem
    CLLocationCoordinate2D sourceCoordinate = self.currentCoordinate;
    MKPlacemark *sourcePlace = [[MKPlacemark alloc]initWithCoordinate:sourceCoordinate];
    MKMapItem *sourceMapItem = [[MKMapItem alloc]initWithPlacemark:sourcePlace];
    sourceMapItem.name = NSLocalizedString(@"nowLocation", @"");
    
    // Decide Target MapItem
    CLLocationCoordinate2D targetLocation;
    if (self.storeInfo.lat == -1) {
        CLGeocoder *geocoder1 = [CLGeocoder new];
        NSString *targetAddress = self.storeInfo.address;
        [geocoder1 geocodeAddressString:targetAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //......
            if (error) {
                NSLog(@"Geocoder fail : %@",error);
                return;
            }
            if (placemarks == 0) {
                NSLog(@"Can not find %@",targetAddress);
                return;
            }
            
            CLPlacemark *placemark = placemarks.firstObject;
            CLLocationCoordinate2D coordinate = placemark.location.coordinate;
            NSLog(@"%@ ==> %f,%f",targetAddress,coordinate.latitude,coordinate.longitude);
            
            // Decide Target MapItem
            MKPlacemark *targetPlace = [[MKPlacemark alloc]initWithPlacemark:placemark];
            MKMapItem *targetMapItem = [[MKMapItem alloc]initWithPlacemark:targetPlace];
            
            // Option
            NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
            
            //[targetMapItem openInMapsWithLaunchOptions:options];
            
            [MKMapItem openMapsWithItems:@[sourceMapItem,targetMapItem] launchOptions:options];
            
        }];
    }else{
        targetLocation = CLLocationCoordinate2DMake(self.storeInfo.lat, self.storeInfo.lng);
        MKPlacemark *targetPlace = [[MKPlacemark alloc]initWithCoordinate:targetLocation];
        MKMapItem *targetMapItem = [[MKMapItem alloc]initWithPlacemark:targetPlace];
        targetMapItem.name = self.storeInfo.name;
        
        // Option
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
        
        //[targetMapItem openInMapsWithLaunchOptions:options];
        
        [MKMapItem openMapsWithItems:@[sourceMapItem,targetMapItem] launchOptions:options];
    }
    
    
}

-(void)getIconImage{
    
    if (self.storeInfo.imageSource) {
        
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSURL*iconURL = [NSURL URLWithString:self.storeInfo.imageSource];
        NSData*iconData = [NSData dataWithContentsOfURL:iconURL];
        UIImage *image = [UIImage imageWithData:iconData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.store2Map.image = image;
        });
    });
        
    }
}

-(void)back2NearFoodTableView{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
