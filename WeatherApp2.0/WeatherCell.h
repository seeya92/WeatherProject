//
//  WeatherCell.h
//  WeatherApp2.0
//
//  Created by Kuryliak Maksym on 24.05.16.
//  Copyright © 2016 Kuryliak Maksym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell

@property (nonatomic, weak)IBOutlet UILabel *dayLbl;
@property (nonatomic, weak)IBOutlet UILabel *minLbl;
@property (nonatomic, weak)IBOutlet UILabel *maxLbl;

@property (nonatomic, weak)IBOutlet UIImageView *weatherImg;
@property (nonatomic, weak)IBOutlet UIImageView *bgImg;

@end
