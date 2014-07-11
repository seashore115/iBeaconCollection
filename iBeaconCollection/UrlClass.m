//
//  UrlClass.m
//  iBeaconCollection
//
//  Created by Apple on 14-6-10.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import "UrlClass.h"

@implementation UrlClass
@synthesize defaultUrl;
@synthesize floorPlan;
@synthesize currentRouteName;
@synthesize routeData;
@synthesize checkArray;
+ (instancetype) sharedManager {
    static UrlClass *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [self new];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    if (self) {
        defaultUrl = @"http://mcc-backend.appspot.com/mcc/floorplan/mapping/" ;
        floorPlan=@"";
        currentRouteName=@"";
        routeData=@"";
        checkArray=[[NSMutableArray alloc]initWithCapacity:100000];
    }
    return self;
}
@end
