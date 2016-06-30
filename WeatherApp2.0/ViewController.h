//
//  ViewController.h
//  WeatherApp2.0
//
//  Created by Kuryliak Maksym on 24.05.16.
//  Copyright © 2016 Kuryliak Maksym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Place.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    
    NSMutableArray *maxTempArray;
    NSMutableArray *minTempArray;
    NSMutableArray *dayArray;
    NSMutableArray *weatherImgArray;
    NSMutableArray *backgroundImgArray;
    
    CLLocationManager *locationManager;
}
@property(weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
@property(nonatomic,weak) Place * selectedPlace;
@property(nonatomic,weak) IBOutlet UITableView *tableView;

@end

