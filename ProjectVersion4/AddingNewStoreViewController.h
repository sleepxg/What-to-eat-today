//
//  AddingNewStoreViewController.h
//  ProjectVersion4
//
//  Created by user34 on 2017/5/25.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreInfo.h"

@protocol AddingNewStoreViewControllerDelegate <NSObject>
-(void)back2RootViewController:(NSMutableArray *)data theType:(NSInteger)type;
@end

@interface AddingNewStoreViewController : UIViewController
@property (nonatomic) NSMutableArray <StoreInfo*> *favoriteData;
@property (nonatomic) id <AddingNewStoreViewControllerDelegate> delegate;

@end
