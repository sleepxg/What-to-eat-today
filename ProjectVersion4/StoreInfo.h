//
//  StoreInfo.h
//  ProjectVersion3
//
//  Created by user34 on 2017/5/16.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@import CoreData;
@interface StoreInfo : NSManagedObject 

@property(nonatomic)NSString*name;
@property(nonatomic)NSString*address;
@property(nonatomic)NSString*phoneNumber;
@property(nonatomic)NSString*webToMap;
@property(nonatomic)NSString*imageSource;
@property(nonatomic)double lat;
@property(nonatomic)double lng;
@property(nonatomic)NSString*placeID;
@property(nonatomic)Boolean isFavorite;

-(void)setAll:(NSMutableDictionary*)storeInfo;
-(void)copyFromAnotherStoreDetail:(StoreInfo*)item;
@end
