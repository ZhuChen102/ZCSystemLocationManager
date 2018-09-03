//
//  ZCSystemLocationManager.h
//  ZCNetWorking
//
//  Created by Zhu on 2018/9/3.
//  Copyright © 2018年 Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^ZCLocationCallbackBlock)(CLLocationCoordinate2D location,NSError *error);
typedef void (^ZCLocationAddressBlock)(NSDictionary *addressDict,NSError *error);
@interface ZCSystemLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) ZCLocationCallbackBlock resultBlock;
@property (nonatomic, copy) ZCLocationAddressBlock addressBlock;
#pragma mark -- 单例
+ (instancetype)sharedInstance;
+ (void)startUpdatingLocationResult:(ZCLocationCallbackBlock)callbackBlock andAddress:(ZCLocationAddressBlock)addressBlock;
+ (void)stopUpdatingLocation;

@end
