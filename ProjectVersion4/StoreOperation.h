//
//  StoreOperation.h
//  ProjectVersion4
//
//  Created by user34 on 2017/5/24.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StoreInfo.h"
@interface StoreOperation : NSOperation
@property (nonatomic) NSString * placeID;
@property (nonatomic) NSInteger type;
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray <StoreInfo*> *data;
@end
