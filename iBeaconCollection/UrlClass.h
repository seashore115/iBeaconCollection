//
//  UrlClass.h
//  iBeaconCollection
//
//  Created by Apple on 14-6-10.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlClass : NSObject{
    NSString *defaultUrl;
    NSString *floorPlan;
    NSString *currentRouteName;
    NSString *routeData;
    NSMutableArray *checkArray;
}
@property(nonatomic,copy) NSString *defaultUrl;
@property(nonatomic,copy) NSString *floorPlan;
@property(nonatomic,copy) NSString *currentRouteName;
@property(nonatomic,copy) NSString *routeData;
@property(nonatomic,copy) NSMutableArray *checkArray;
+ (instancetype) sharedManager;
@end
