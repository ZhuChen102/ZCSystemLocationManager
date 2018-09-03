//
//  BBSystemLocationManager.m
//  BanBanApp
//
//  Created by Zhu on 2018/7/3.
//  Copyright © 2018年 时伟平. All rights reserved.
//

#import "ZCSystemLocationManager.h"

@implementation ZCSystemLocationManager
#pragma mark -- 单例
+ (instancetype)sharedInstance {
    static ZCSystemLocationManager *_manager;
    if (!_manager) {
        _manager = [[ZCSystemLocationManager alloc]init];
    }
    return _manager;
}

#pragma mark -- 开始定位
+ (void)startUpdatingLocationResult:(ZCLocationCallbackBlock)callbackBlock andAddress:(ZCLocationAddressBlock)addressBlock {
    [ZCSystemLocationManager sharedInstance].resultBlock = callbackBlock;
    [ZCSystemLocationManager sharedInstance].addressBlock = addressBlock;
    [[ZCSystemLocationManager sharedInstance].locationManager startUpdatingLocation];
}
#pragma mark -- 结束定位
+ (void)stopUpdatingLocation {
    [[ZCSystemLocationManager sharedInstance].locationManager stopUpdatingLocation];
}
#pragma mark - 代理
#pragma mark -- 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [ZCSystemLocationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D customCoordinate = [[ZCSystemLocationManager sharedInstance] BD09FromGCJ02:currentLocation.coordinate];
    [ZCSystemLocationManager sharedInstance].resultBlock(customCoordinate, nil);
    //地址反编译
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            [ZCSystemLocationManager sharedInstance].addressBlock(nil, error);
        }else {
            CLPlacemark *place = [placemarks firstObject];
            if (place) {
                NSDictionary *loactionAddress = [place addressDictionary];
                [ZCSystemLocationManager sharedInstance].addressBlock(loactionAddress, nil);
            }
        }
    }];
    
    
    
}
#pragma mark -- 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    CLLocationCoordinate2D location1;
    location1.latitude = 0;
    location1.longitude = 0;
    [ZCSystemLocationManager sharedInstance].resultBlock(location1, error);
}
#pragma mark - 坐标转换
#pragma mark -- 百度坐标转高德坐标
- (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor {
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    CLLocationDegrees z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationDegrees gg_lon = z * cos(theta);
    CLLocationDegrees gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}

#pragma mark -- 高德坐标转百度坐标
- (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor {
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}
//高德转百度  需要百度地图SDK
//- (CLLocationCoordinate2D)baiduLocationFromEarth:(CLLocationCoordinate2D)earthCoordinate {
//
//    NSDictionary *testdic =BMKConvertBaiduCoorFrom(earthCoordinate,BMK_COORDTYPE_GPS);
//    //转换GPS坐标至百度坐标
//    NSString *xstr=[testdic objectForKey:@"x"];
//    NSString *ystr=[testdic objectForKey:@"y"];
//
//    NSData *xdata=[[NSData alloc] initWithBase64EncodedString:xstr options:0];
//    NSData *ydata=[[NSData alloc] initWithBase64EncodedString:ystr options:0];
//
//    NSString *xlat=[[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
//    NSString *ylng=[[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
//
//    earthCoordinate.latitude=[xlat doubleValue];
//    earthCoordinate.longitude=[ylng doubleValue];
//    return earthCoordinate;
//}

#pragma mark - 懒加载
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        if([CLLocationManager locationServicesEnabled]) {
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 5.0;
        }else {//提示用户无法进行定位操作

        }
    }
    return _locationManager;
}


@end
