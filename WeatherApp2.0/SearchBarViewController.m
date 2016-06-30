//
//  SearchBarViewController.m
//  WeatherApp2.0
//
//  Created by Kuryliak Maksym on 27.06.16.
//  Copyright © 2016 Kuryliak Maksym. All rights reserved.
//

#import "SearchBarViewController.h"
#import "Place.h"
#import "ViewController.h"

@interface SearchBarViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    
}


@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    placesArray = [[NSMutableArray alloc]init];
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
        [placesArray removeAllObjects];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *array = jsonData[@"predictions"];
        for (NSDictionary *result in array) {
            Place *place = [[Place alloc]init];
            NSArray *terms = result[@"terms"];
            NSDictionary *placeValue = terms[0];
            NSString *name = placeValue[@"value"];
//            NSString *name = result[@"terms"][0][@"value"];
            NSString *reference = [result valueForKey:@"reference"];
            place.name = name;
            place.reference = reference;
            [placesArray addObject:place];
        }
        [self.tableView reloadData];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
}

- (NSInteger)tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section{
    return (NSInteger)placesArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell" forIndexPath:indexPath];
    Place *place = placesArray[indexPath.row];
    cell.textLabel.text = place.name;
    return cell;
}

- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender{
    ViewController *vca = (ViewController *)segue.destinationViewController;
    NSIndexPath *selectedPath = [self.tableView indexPathForCell:sender];
    Place *place = placesArray[selectedPath.row];
    vca.selectedPlace = place;
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
