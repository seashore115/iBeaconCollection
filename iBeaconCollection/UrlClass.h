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
}
@property(nonatomic,copy) NSString *defaultUrl;
+ (instancetype) sharedManager;
@end
