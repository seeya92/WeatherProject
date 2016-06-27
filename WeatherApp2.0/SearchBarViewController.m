//
//  SearchBarViewController.m
//  WeatherApp2.0
//
//  Created by Kuryliak Maksym on 27.06.16.
//  Copyright © 2016 Kuryliak Maksym. All rights reserved.
//

#import "SearchBarViewController.h"

@interface SearchBarViewController () <UISearchBarDelegate> {
    
}


@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&language=pt_BR&key=AIzaSyCrOxwHPOMAj7IaK5vwZRmkVcsRnd5NZOE", searchText];
    
    NSError *error;
    NSURLResponse *response;
    NSData* data = [NSURLConnection sendSynchronousRequest:
                    [NSURLRequest requestWithURL:
                     [NSURL URLWithString:urlString]]
                                         returningResponse:&response
                                                     error:&error];
    
    if (data) {
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *array = jsonData[@"predictions"];
        for (NSDictionary *result in array) {
            NSString *name = [result valueForKey:@"terms"][0][@"value"];
            NSString *placeId = [result valueForKey:@"place_id"];
            NSString *lon = [result valueForKey:@"lon"];
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
