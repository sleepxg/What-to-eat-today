//
//  FavoriteTableViewController.h
//  ProjectVersion4
//
//  Created by 鄭文 on 2017/5/27.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreInfo.h"

@protocol FavoriteTableViewControllerDelegate <NSObject>
-(void)back2RootViewController:(NSMutableArray *)data theType:(NSInteger)type;
-(CLLocationCoordinate2D)getLocation;
@end

@interface FavoriteTableViewController : UITableViewController

@property (nonatomic) NSInteger type;
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic) NSMutableArray <StoreInfo*> *favoriteData;
@property (nonatomic) id <FavoriteTableViewControllerDelegate> delegate;

@end
