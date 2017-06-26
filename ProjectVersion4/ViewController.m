//
//  ViewController.m
//  ProjectVersion4
//
//  Created by user34 on 2017/5/24.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import "ViewController.h"
#import "StoreInfo.h"
#import "CoreDataHelper.h"
#import "NearFoodTableViewController.h"
#import "AddingNewStoreViewController.h"
#import "FavoriteTableViewController.h"
@import MessageUI;
@import StoreKit;
@import Firebase;
@import GoogleMobileAds;

#define AD_UNITID @"ca-app-pub-8413667152641702/4657691679"

@interface ViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,NearFoodTableViewControllerDelegate,GADBannerViewDelegate,FavoriteTableViewControllerDelegate>
{
    NSArray *type;
    NSArray *image;
    NSMutableArray <StoreInfo*> *foodData;
    NSMutableArray <StoreInfo*> *cafeData;
    NSMutableArray <StoreInfo*> *bakeryData;
    NSMutableArray <StoreInfo*> *favoriteData;
    
    CLLocationManager * locationManger;
    CLLocationCoordinate2D currentCoordinate;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) GADBannerView * bannerView;
@end

@implementation ViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        type = @[NSLocalizedString(@"Food", @""),NSLocalizedString(@"Cafe", @""),NSLocalizedString(@"Bakery", @"")];
        UIImage *icon1 = [UIImage imageNamed:@"003-plate-fork-and-knife"];
        UIImage *icon2 = [UIImage imageNamed:@"002-coffee-cup"];
        UIImage *icon3 = [UIImage imageNamed:@"001-bread"];
        image = @[icon1,icon2,icon3];
        [self queryFromCoreData];
        
        NSLog(@"home is : %@",NSHomeDirectory());
    }
    return self;
}

-(void)queryFromCoreData{
    CoreDataHelper *coreData = [CoreDataHelper sharedInstance];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    
    NSError *error;
    NSArray *result1=[coreData.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"query From coreData error %@",error);
        foodData = [NSMutableArray array];
    }else{
        foodData = [NSMutableArray arrayWithArray:result1];
    }

    request = [NSFetchRequest fetchRequestWithEntityName:@"Cafe"];
    
    NSArray *result2=[coreData.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"query From coreData error %@",error);
        cafeData = [NSMutableArray array];
    }else{
        cafeData = [NSMutableArray arrayWithArray:result2];
    }
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"Bakery"];
    
    NSArray *result3=[coreData.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"query From coreData error %@",error);
        bakeryData = [NSMutableArray array];
    }else{
        bakeryData = [NSMutableArray arrayWithArray:result3];
    }

    request = [NSFetchRequest fetchRequestWithEntityName:@"Favorite"];
    
    NSArray *result4=[coreData.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"query From coreData error %@",error);
        favoriteData = [NSMutableArray array];
    }else{
        favoriteData = [NSMutableArray arrayWithArray:result4];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAdvertice];
    self.navigationItem.title = NSLocalizedString(@"root.title", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"AddByUser", @"") style:UIBarButtonItemStylePlain target:self action:@selector(addNewStoreByUser)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Favorite", @"") style:UIBarButtonItemStylePlain target:self action:@selector(goToMyFavorite)];
    
    [self startLocation];
    
}

-(void) goToMyFavorite{
//    NearFoodTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"nearFoodTable"];
//    nextVC.currentStoreData = favoriteData;
//    nextVC.type = 0;
//    nextVC.currentCoordinate = currentCoordinate;
//    nextVC.delegate = self;
//    [self.navigationController pushViewController:nextVC animated:YES];
    FavoriteTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"favoriteTavleViewController"];
    nextVC.favoriteData = favoriteData;
    nextVC.type = 0;
    nextVC.delegate = self;
    nextVC.currentCoordinate = currentCoordinate;
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)addNewStoreByUser{
    
//    NSArray *tmp;
//    tmp = @{};
//    tmp[1];
    
    AddingNewStoreViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addNewStoreViewController"];
    nextVC.favoriteData = favoriteData;
    
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)setAdvertice{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.adUnitID = AD_UNITID;
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return type.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = type[indexPath.row];
    cell.imageView.image = image[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NearFoodTableViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"nearFoodTable"];
    
    switch (indexPath.row) {
        case 0:
            nextVC.type = 1;
            nextVC.currentStoreData = foodData;
            break;
        case 1:
            nextVC.type = 2;
            nextVC.currentStoreData = cafeData;
            break;
        case 2:
            nextVC.type = 3;
            nextVC.currentStoreData = bakeryData;
            break;
        default:
            break;
    }
    nextVC.favoriteStoreData = favoriteData;
    nextVC.currentCoordinate = currentCoordinate;
    nextVC.delegate = self;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark NearFoodTableViewControllerDelegate Methods
-(void)back2RootViewController:(NSMutableArray *)data theType:(NSInteger)type{
    switch (type) {
        case 1:
            foodData = data;
            break;
        case 2:
            cafeData = data;
            break;
        case 3:
            bakeryData = data;
            break;
        case 0:
            favoriteData = data;
            break;
        default:
            break;
    }
}

-(CLLocationCoordinate2D)getLocation{
    return currentCoordinate;
}

#pragma mark - CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentLocation = locations.lastObject;
    
    currentCoordinate = currentLocation.coordinate;
    
    //NSLog(@"location %f,%f",currentCoordinate.latitude,currentCoordinate.longitude);
}

-(void) startLocation{
    locationManger = [CLLocationManager new];
    
    //Ask user's permission
    [locationManger requestWhenInUseAuthorization];
    
    locationManger.delegate = self;
    //準確度以及活動方式
    locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    locationManger.activityType = CLActivityTypeAutomotiveNavigation;
    [locationManger startUpdatingLocation];
}

#pragma mark GADBannerViewDelegate
-(void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    if (![bannerView superview]) {
        [self.view addSubview:bannerView];
        self.tableTopConstraint.active = NO;
        NSArray *vs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top][ad][tableView]" options:0 metrics:nil views:@{@"top":self.topLayoutGuide,@"ad":bannerView,@"tableView":self.tableView}];
        NSArray *hs = [NSLayoutConstraint constraintsWithVisualFormat:@"|[ad]|" options:0 metrics:nil views:@{@"ad":bannerView}];
        
        [NSLayoutConstraint activateConstraints:vs];
        [NSLayoutConstraint activateConstraints:hs];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
