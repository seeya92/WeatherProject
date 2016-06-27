//
//  Place.h
//  WeatherApp2.0
//
//  Created by Kuryliak Maksym on 27.06.16.
//  Copyright © 2016 Kuryliak Maksym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface Place : NSObject {
    NSMutableArray *placeArray;
}

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) CLLocation *placeId;

@end
