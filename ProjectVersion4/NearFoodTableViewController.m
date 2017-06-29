//
//  NearFoodTableViewController.m
//  ProjectVersion4
//
//  Created by user34 on 2017/5/24.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import "NearFoodTableViewController.h"
#import "DetailViewController.h"
#import "StoreOperation.h"
#import "CoreDataHelper.h"

#define GOOGLE_PLACES_API @"Your google places api key"

@interface NearFoodTableViewController ()
@property (nonatomic) NSOperationQueue *queue;

@end

@implementation NearFoodTableViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.queue = [[NSOperationQueue alloc]init];
        self.queue.maxConcurrentOperationCount = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    UIBarButtonItem *btnA = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    UIBarButtonItem *btnB = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Select", @"") style:UIBarButtonItemStyleDone target:self action:@selector(randomSelect)];
    UIBarButtonItem *btnC = self.editButtonItem;
    NSArray <UIBarButtonItem*> *btns = @[btnA,btnB,btnC];
    
    self.navigationItem.rightBarButtonItems = btns;
     
    if ( (self.currentStoreData.count == 0) && (self.type != 0)) {
        self.currentStoreData = [NSMutableArray array];
        [self queryStore];
    }
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (self.type) {
        case 1:
            self.navigationItem.title = NSLocalizedString(@"Food", @"");
            break;
        case 2:
            self.navigationItem.title = NSLocalizedString(@"Cafe", @"");
            break;
        case 3:
            self.navigationItem.title = NSLocalizedString(@"Bakery", @"");
            break;
        default:
            break;
    }
}

-(void)refreshData{
    self.currentCoordinate = [self.delegate getLocation];
        NSManagedObjectContext *contex = [CoreDataHelper sharedInstance].managedObjectContext;
    
    for (StoreInfo *tmp in self.currentStoreData) {
        [contex deleteObject:tmp];
    }
    NSError *error;
    [contex save:&error];
    [self.currentStoreData removeAllObjects];

    if (error) {
        NSLog(@"refreshData error here : %@",error);
    }else{
        
        [self.refreshControl endRefreshing];
        
        [self.tableView reloadData];
        [self queryStore];
    }
    
}

-(void)queryStore{
    NSString *searchType;
    switch (self.type) {
        case 1:
            searchType = @"food";
            self.navigationItem.title = NSLocalizedString(@"Food", @"");
            break;
        case 2:
            searchType = @"cafe";
            self.navigationItem.title = NSLocalizedString(@"Cafe", @"");
            break;
        case 3:
            searchType = @"bakery";
            self.navigationItem.title = NSLocalizedString(@"Bakery", @"");
            break;
        default:
            searchType = @"food";
            break;
    }
    
    // 目前搜尋半徑預設100
    NSString * searchStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=%f,%f&radius=%@&type=%@&key=%@",self.currentCoordinate.latitude,self.currentCoordinate.longitude,@"100",searchType,GOOGLE_PLACES_API];
    
    NSURL * url = [NSURL URLWithString:searchStr];
    
    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        NSLog(@"error : %@",error);
    }else{
        if ([dictionary[@"status"] isEqualToString:@"OK"]) {
            NSArray *storeResults = dictionary[@"results"];
            for (int i = 0 ; i < storeResults.count ; i++) {
                NSMutableDictionary * storeDictionary = storeResults[i];
                //NSLog(@"placeID => %@",storeDictionary[@"place_id"]);
                NSString *placeID = storeDictionary[@"place_id"];
                StoreOperation* storeOperation = [[StoreOperation alloc]init];
                storeOperation.placeID = placeID;
                storeOperation.data = self.currentStoreData;
                storeOperation.tableView = self.tableView;
                storeOperation.type = self.type;
                //NSLog(@"placeID : %@",placeID);
                [self.queue addOperation:storeOperation];
            }
            
            
        }
    }

}

-(void)back{
    [self.delegate back2RootViewController:self.currentStoreData theType:self.type];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)randomSelect{
    if (self.currentStoreData.count >= 1 ) {
        NSInteger x = arc4random()%self.currentStoreData.count;
        NSIndexPath * index = [NSIndexPath indexPathForRow:x inSection:1];
        [self tableView:self.tableView didSelectRowAtIndexPath:index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentStoreData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    StoreInfo*tmp = self.currentStoreData[indexPath.row];
                            
    cell.textLabel.text = tmp.name;
    cell.detailTextLabel.text = tmp.address;
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    StoreInfo *tmp = self.currentStoreData[indexPath.row];
    nextVC.currentCoordinate = self.currentCoordinate;
    nextVC.storeInfo = tmp;
    nextVC.favoriteData = self.favoriteStoreData;
    nextVC.type = self.type;
    //nextVC.delegate = self;
    [self.navigationController pushViewController:nextVC animated:YES];
}

//-(void)isAddingToFavorite:(Boolean)check storeDetail:(StoreInfo*)storeDetail{
//
//    if (check) {
//        Boolean isRepeat = false;
//        
//        for (StoreInfo *test in self.favoriteStoreData) {
//            if ([test.name isEqualToString:storeDetail.name]) {
//                isRepeat = true;
//            }
//        }
//        
//        if (!isRepeat) {
//            NSManagedObjectContext *contex = [CoreDataHelper sharedInstance].managedObjectContext;
//            StoreInfo *temp = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:contex];
//            temp = storeDetail;
//            [self.favoriteStoreData addObject:temp];
//            [contex save:nil];
//        }
//    }
//
//}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        StoreInfo *temp = self.currentStoreData[indexPath.row];
         NSManagedObjectContext *contex = [CoreDataHelper sharedInstance].managedObjectContext;
        [contex deleteObject:temp];
        [contex save:nil];
        [self.currentStoreData removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
