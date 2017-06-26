//
//  NearFoodTableViewController.h
//  ProjectVersion4
//
//  Created by user34 on 2017/5/24.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreInfo.h"

@protocol NearFoodTableViewControllerDelegate <NSObject>
-(void)back2RootViewController:(NSMutableArray*)data theType:(NSInteger)type;
-(CLLocationCoordinate2D)getLocation;
@end

@interface NearFoodTableViewController : UITableViewController

@property (nonatomic) NSInteger type;
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic) NSMutableArray <StoreInfo*> *currentStoreData;
@property (nonatomic) NSMutableArray <StoreInfo*> *favoriteStoreData;
@property (nonatomic) id <NearFoodTableViewControllerDelegate> delegate;

@end
