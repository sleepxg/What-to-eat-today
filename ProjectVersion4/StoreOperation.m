//
//  StoreOperation.m
//  ProjectVersion3
//
//  Created by user34 on 2017/5/18.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import "StoreOperation.h"
#import "CoreDataHelper.h"

#define GOOGLE_PLACES_API @"AIzaSyB1KGmAFZGJp0v8L1SEiDluvysen-mzg24"

@implementation StoreOperation
-(void)main{
    
    
    NSString * searchStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",self.placeID,GOOGLE_PLACES_API];
    
    NSURL * url = [NSURL URLWithString:searchStr];
    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        NSLog(@"error : %@",error);
    }else{
        if ([dictionary[@"status"] isEqualToString:@"OK"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *storeResult = dictionary[@"result"];
                
                NSManagedObjectContext *contex = [CoreDataHelper sharedInstance].managedObjectContext;
                StoreInfo *storeInfo;
                
                switch (self.type) {
                    case 1:
                        storeInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:contex];
                        break;
                    case 2:
                        storeInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Cafe" inManagedObjectContext:contex];
                        break;
                    case 3:
                        storeInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Bakery" inManagedObjectContext:contex];
                        break;
                    default:
                        
                        break;
                }
                
                
                [storeInfo setAll:storeResult];
                NSLog(@"store Name:%@",storeInfo.name);
                [self.data addObject:storeInfo];
                NSError *error;
                [contex save:&error];
                if (error) {
                    NSLog(@"StoreOperation error : %@",error);
                }
                
                [self.tableView reloadData];

            });
            
        }
    }
}
@end

