//
//  DetailViewController.h
//  ProjectVersion4
//
//  Created by user34 on 2017/5/24.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreInfo.h"


@interface DetailViewController : UIViewController
@property (nonatomic) NSMutableArray <StoreInfo*>*favoriteData;
@property (nonatomic) StoreInfo * storeInfo;
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic) NSInteger type;
@end
