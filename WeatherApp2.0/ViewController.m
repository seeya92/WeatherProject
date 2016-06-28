//
//  ViewController.m
//  WeatherApp2.0
//
//  Created by Kuryliak Maksym on 24.05.16.
//  Copyright © 2016 Kuryliak Maksym. All rights reserved.
//

#import "ViewController.h"
#import "WeatherCell.h"
#import "Place.h"
#import "SearchBarViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     locationManager = [CLLocationManager new];
     locationManager.delegate = self;
     locationManager.distanceFilter = kCLDistanceFilterNone;
     locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0 &&
     [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
     //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
     ) {
     // Will open an confirm dialog to get user's approval
     [locationManager requestWhenInUseAuthorization];
     //[_locationManager requestAlwaysAuthorization];
     } else {
     [locationManager startUpdatingLocation]; //Will update location immediately
     }
    
    
    maxTempArray = [[NSMutableArray alloc]init];
    minTempArray = [[NSMutableArray alloc]init];
    dayArray = [[NSMutableArray alloc]init];
    weatherImgArray = [[NSMutableArray alloc]init];
    backgroundImgArray = [[NSMutableArray alloc]init];
    //placeArray = [[NSMutableArray alloc]init];
    
    /*
    NSArray *myFavoriteScreenArray = [NSArray arrayWithObjects:<#(nonnull id), ...#>, nil]
    NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritesScreen;
    
    if ([favorites objectForKey:@favoritesScreen] == nil) {
        NSMutableArray *favoritesArray = [[NSMutableArray alloc]init];
        [favorites setObject:favoritesArray forKey:@favoritesScreen];
        [favoritesArray release];
    }
    NSMutableArray *tempArray = [[favorites objectForKey:@favoritesScreen] mutableCopy];
    favoritesScreen = tempArray;
    [tempArray release];
    [favoritesScreen addObject:[];
    */
    
    
}

- (void)getLocationLatitude:(NSString*)lat andLongtitude:(NSString*)lon{
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/1d3cd010bfb57527975741a9c73b7cb2/%@,%@",lat,lon];
    
    NSError *error;
    NSURLResponse *response;
    NSData* data = [NSURLConnection sendSynchronousRequest:
                    [NSURLRequest requestWithURL:
                     [NSURL URLWithString:urlString]]
                                         returningResponse:&response
                                                     error:&error];
    
    if (data) {
        
        NSData *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSData *currentData = [jsonData valueForKey:@"currently"];
        
        NSString * temperatureString = [currentData valueForKey:@"temperature"];
        
        float fahrenheit = temperatureString.floatValue;
        
        float celsius = (fahrenheit-32.0)*(5.0/9.0);
        
        NSLog(@"Temperature in Ternopil now in C: %.2f", celsius);
        NSLog(@"Temperature in Ternopil now in F: %.2f", fahrenheit);
        
        NSData *dayData = [jsonData valueForKey:@"daily"];
        NSArray *dataArray = [dayData valueForKey:@"data"];
        NSDate *current = [NSDate date];
        NSInteger weekDay = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:current] weekday];
        NSLog(@"weekday: %ld", (long)weekDay);
        
        for (int i = 0; i<dataArray.count; i++) {
            NSData *tempData = [dataArray objectAtIndex:i];
            NSString *minText = [tempData valueForKey:@"temperatureMin"];
            NSString *maxText = [tempData valueForKey:@"temperatureMax"];
            
            NSString *minValue = [self getCelsius:minText.floatValue];
            NSString *maxValue = [self getCelsius:maxText.floatValue];
            
            [minTempArray addObject:minValue];
            [maxTempArray addObject:maxValue];
            
            int day = (int)weekDay+i;
            [dayArray addObject:[self getShortCutForDay:day]];
            
            NSString *iconString = [tempData valueForKey:@"icon"];
            
            if ([iconString isEqualToString:@"clear-day"]) {
                [weatherImgArray addObject:@"sunnyIcon"];
                [backgroundImgArray addObject:@"sunnyBgIcon"];
            }
            else if ([iconString isEqualToString:@"clear-night"]) {
                [weatherImgArray addObject:@"sunnyIcon"];
                [backgroundImgArray addObject:@"sunnyBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"rain"]) {
                [weatherImgArray addObject:@"rainyIcon"];
                [backgroundImgArray addObject:@"grayBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"snow"]) {
                [weatherImgArray addObject:@"snowyIcon"];
                [backgroundImgArray addObject:@"white-grayBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"sleet"]) {
                [weatherImgArray addObject:@"snowyIcon"];
                [backgroundImgArray addObject:@"white-grayBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"wind"]) {
                [weatherImgArray addObject:@"cloudyIcon"];
                [backgroundImgArray addObject:@"grayBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"fog"]) {
                [weatherImgArray addObject:@"cloudyIcon"];
                [backgroundImgArray addObject:@"grayBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"cloudy"]) {
                [weatherImgArray addObject:@"cloudyIcon"];
                [backgroundImgArray addObject:@"grayBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"partly-cloudy-day"]) {
                [weatherImgArray addObject:@"sunny-cloudyIcon"];
                [backgroundImgArray addObject:@"white-grayBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"partly-cloudy-night"]) {
                [weatherImgArray addObject:@"cloudyIcon"];
                [backgroundImgArray addObject:@"grayBgIcon"];
            }
            
            else if ([iconString isEqualToString:@"partly-cloudy-night"]) {
                [weatherImgArray addObject:@"cloudyIcon"];
                [backgroundImgArray addObject:@"grayBgIcon"];
            }
            else {
                [weatherImgArray addObject:@"cloudyIcon"];
                [backgroundImgArray addObject:@"grayBgIcon"];
            }
        }
        [_tableView reloadData];
    }
    else {
        
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated {
    if (self.selectedPlace != nil) {
        NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=AIzaSyBLI_E0ymJCvHTz-29NszlLKp5IZnK1OQk", self.selectedPlace.reference];
        
        NSError *error;
        NSURLResponse *response;
        NSData* data = [NSURLConnection sendSynchronousRequest:
                        [NSURLRequest requestWithURL:
                         [NSURL URLWithString:urlString]]
                                             returningResponse:&response
                                                         error:&error];
        
        if (data) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *array = jsonData[@"address_components"];
            for (NSDictionary *result in array) {
                NSString *geometry = [result valueForKey:@"geometry"][0][@"value"];
                NSString *location = [result valueForKey:@"location"];
            }
            [self.tableView reloadData];
        }

    }
}




-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WeatherCell";
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.minLbl.text = [NSString stringWithFormat:@"%@", [minTempArray objectAtIndex:indexPath.row]];
    cell.maxLbl.text = [NSString stringWithFormat:@"%@", [maxTempArray objectAtIndex:indexPath.row]];
    cell.dayLbl.text = [NSString stringWithFormat:@"%@", [dayArray objectAtIndex:indexPath.row]];
    cell.weatherImg.image = [UIImage imageNamed:[weatherImgArray objectAtIndex:indexPath.row]];
    cell.bgImg.image = [UIImage imageNamed:[backgroundImgArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section{
    return (NSInteger)minTempArray.count;
}

- (NSString *)getShortCutForDay:(int)day{
    
    NSString *shortCut = [[NSString alloc] init];
    
    if (day>7) {
        day = day-7;
    }
    
    switch (day) {
        case 1:
            shortCut = @"Понеділок";
            break;
        case 2:
            shortCut = @"Вівторок";
            break;
        case 3:
            shortCut = @"Середа";
            break;
        case 4:
            shortCut = @"Четвер";
            break;
        case 5:
            shortCut = @"П'ятниця";
            break;
        case 6:
            shortCut = @"Субота";
            break;
        case 7:
            shortCut = @"Неділя";
            break;
        default:
            break;
    }
    return shortCut;
}


- (NSString *)getCelsius:(float)fahrenheit {
    
    NSString *returnString = [NSString stringWithFormat:@"%.1f",((fahrenheit-32.0)*(5.0/9.0))];
    
    return returnString;
}
/*
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        [self newWeatherRequestWithLocationCoords:coords];
    }
}
*/


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:location.coordinate.longitude];
    [self getLocationLatitude:[lat stringValue] andLongtitude:[lon stringValue]];
    [manager stopUpdatingLocation];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
