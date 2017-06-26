//
//  StoreInfo.m
//  ProjectVersion3
//
//  Created by user34 on 2017/5/16.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import "StoreInfo.h"

@interface StoreInfo()

@end

@implementation StoreInfo

@dynamic name,address,phoneNumber,webToMap,imageSource,placeID,lat,lng,isFavorite;

-(void)setAll:(NSMutableDictionary*)storeInfo{
    
    self.name = storeInfo[@"name"];
    self.address = storeInfo[@"vicinity"];
    self.phoneNumber = storeInfo[@"formatted_phone_number"];
    self.webToMap = storeInfo[@"url"];
    self.imageSource = storeInfo[@"icon"];
    self.placeID = storeInfo[@"place_id"];
    
    self.lat = [storeInfo[@"geometry"][@"location"][@"lat"] doubleValue];
    self.lng = [storeInfo[@"geometry"][@"location"][@"lng"] doubleValue];
    
    self.isFavorite = false;
}



-(void)copyFromAnotherStoreDetail:(StoreInfo*)item{
    self.name = item.name;
    self.address = item.address;
    self.phoneNumber = item.phoneNumber;
    self.webToMap = item.webToMap;
    self.imageSource = item.imageSource;
    self.placeID = item.placeID;
    self.lat = item.lat;
    self.lng = item.lng;
    self.isFavorite = item.isFavorite;
}

@end
