//
//  ViewController.m
//  LocationDemo
//
//  Created by Zhu on 2018/9/3.
//  Copyright © 2018年 Zhu. All rights reserved.
//

#import "ViewController.h"
#import "ZCSystemLocationManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ZCSystemLocationManager startUpdatingLocationResult:^(CLLocationCoordinate2D location, NSError *error) {
        NSLog(@"lat:%f--lng:%f",location.latitude,location.longitude);
    } andAddress:^(NSDictionary *addressDict, NSError *error) {
        NSLog(@"%@",addressDict);
    }];
    
}



@end
