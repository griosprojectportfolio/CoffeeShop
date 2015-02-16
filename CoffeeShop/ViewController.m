//
//  ViewController.m
//  CoffeeShop
//
//  Created by GrepRuby on 06/02/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

#import "ViewController.h"
#import "RequestConnection.h"
#import "Reachability.h"
#import "LocationInfo.h"
#import "CustomCoffeeShopInfoCell.h"
#import "MapViewController.h"

#define FOURSQUARE_API @"https://api.foursquare.com/v2/venues/search"

#define IS_IOS7	(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)
#define IS_IOS8	(([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)

@interface ViewController () {

    CLGeocoder *geocoder;
    UISearchBar *searchBarCoffee;
    UIBarButtonItem *barbuttonSearch;
    CLLocationCoordinate2D currentLocation;
}

@property (nonatomic) float latitute;
@property (nonatomic) float longitute;
@property (nonatomic, strong) NSMutableArray *mArryLocation;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
        //Coffee Shop //categoryId=4d4b7105d754a06374d81259
        //4bf58dd8d48988d1e0931735

        //venues/explore?ll=22.6871948,75.861458&categoryId= 4bf58dd8d48988d1e0931735


    [self getCurrentLocation];

    self.navigationController.navigationBar.translucent = NO;

    self.latitute = 22.6871948;
    self.longitute = 75.861458;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;

    [self performSelector:@selector(getFoursquareData) withObject:nil afterDelay:0.1];

    self.mArryLocation = [[NSMutableArray alloc]init];
    self.title = @"Coffee shops";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
        //user location
    self.mapVw.zoomEnabled = YES;
    self.mapVw.showsUserLocation = YES;

    barbuttonSearch = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtnTapped)];
    self.navigationItem.rightBarButtonItem = barbuttonSearch;

    CLLocationCoordinate2D coordinate2d;
    coordinate2d.latitude = self.latitute;
    coordinate2d.longitude = self.longitute;

    //comment for devide

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate2d, 1000, 1000);
    [self.mapVw setRegion:[self.mapVw regionThatFits:region] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBtnTapped {

    self.navigationItem.rightBarButtonItem = nil;
    searchBarCoffee = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 10 , 300, 32)];
    searchBarCoffee.delegate = self;
    searchBarCoffee.showsCancelButton = YES;
    [self.navigationController.navigationBar addSubview:searchBarCoffee];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    [searchBarCoffee removeFromSuperview];
    self.navigationItem.rightBarButtonItem = barbuttonSearch;
}

#pragma mark - Map View Delgate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 120, 120);
    [self.mapVw setRegion:[self.mapVw regionThatFits:region] animated:YES];

    currentLocation = userLocation.coordinate;
}

- (NSMutableArray *)createAnnotations {

    NSMutableArray *annotations = [[NSMutableArray alloc] init];
        //Read locations details from plist
    for (LocationInfo *objLocation in self.mArryLocation) {

        NSNumber *latitude = [NSNumber numberWithFloat:objLocation.latitute];
        NSNumber * longitude = [NSNumber numberWithFloat:objLocation.longitute];

            //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = coordinate;

        [annotations addObject:annotation];
    }
    return annotations;
}

#pragma mark - Get current location

- (void)getCurrentLocation {

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    if(IS_IOS8) {
            // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    CLLocation *currentLocation1 = newLocation;
    self.latitute = currentLocation1.coordinate.latitude;
    self.longitute = currentLocation1.coordinate.longitude;

    NSLog(@"%f", self.longitute);
}

- (NSString *)dateForFourSquare {

    NSDate *date = [NSDate new];
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyyMMdd"];
    NSString *strDate = [formate stringFromDate:date];

    return strDate;
}

#pragma mark - Make request get location from foursquare

- (void)getFoursquareData {

    [self.mArryLocation removeAllObjects];
    [self.locationManager stopUpdatingLocation];

        //check request of address
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                        message:@"Please check your network."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else {

            //api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=CLIENT_ID&client_secret=CLIENT_SECRET&v=YYYYMMDD

        NSString *strLatLong = [NSString stringWithFormat:@"%f,%f",self.latitute, self.longitute];

            //section:@"coffee"
//        NSDictionary *param = @{@"ll":strLatLong,
//                                @"client_id":@"G0JBWOD2KAB55OLARVPAQRJFTY5VB20FFWGLOIJGWLJ3FMDI",
//                                @"client_secret":@"UGZXCUOYHDHH0ANXESMDHJEQ23WAILPT3ZXVWRMLOGWENMCY",
//                                @"v":[self dateForFourSquare],
//                                @"section":@"food"};

        NSDictionary *param = @{@"ll":strLatLong,
                                @"client_id":@"G0JBWOD2KAB55OLARVPAQRJFTY5VB20FFWGLOIJGWLJ3FMDI",
                                @"client_secret":@"UGZXCUOYHDHH0ANXESMDHJEQ23WAILPT3ZXVWRMLOGWENMCY",
                                @"v":[self dateForFourSquare],
                                @"categoryId":@"4bf58dd8d48988d1e0931735"};

        [RequestConnection sendRequestWithGetUrlForFoursquare:FOURSQUARE_API param:param delegate:self success:@selector(successfullyGetLocation:) failure:@selector(failureInResponse:)];
    }
}


- (void)failureInResponse:(NSDictionary*)resultParam {

    NSLog(@"Error");
}


#pragma mark - successfully get response

- (void)successfullyGetLocation:(NSDictionary*)resultParam {

    if ([resultParam objectForKey:@"response"]) {

        NSDictionary *dictResult = [resultParam objectForKey:@"response"];
        NSArray *arryReault = [dictResult objectForKey:@"venues"];

        for (NSDictionary*dictLocation in arryReault) {

            LocationInfo *objLocation = [[LocationInfo alloc]init];

            objLocation.name = [dictLocation valueForKey:@"name"];

            NSDictionary *location = [dictLocation objectForKey:@"location"];

            if( [[location valueForKey:@"formattedAddress"]count] != 0) {
                objLocation.address = [[location valueForKey:@"formattedAddress"]objectAtIndex:0];
            }

            objLocation.distance = [NSString stringWithFormat:@"%@", [location valueForKey:@"distance"]];
            objLocation.latitute = [[location valueForKey:@"lat"] floatValue];
            objLocation.longitute = [[location valueForKey:@"lng"] floatValue];

            [self.mArryLocation addObject:objLocation];

            if ([[dictLocation valueForKey:@"categories"] count] > 0) {

                NSArray *category = [dictLocation valueForKey:@"categories"];
                if(![[[category objectAtIndex:0] valueForKey:@"icon"] isKindOfClass:[NSNull class]]){
                    id icon =[[category objectAtIndex:0] valueForKey:@"icon"];

                    id prefix = [icon valueForKey:@"prefix"];
                    id suffix = [icon valueForKey:@"suffix"];
                    objLocation.icon = [NSString stringWithFormat:@"%@bg_32%@",prefix,suffix];
                }
            }

            }
        }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:TRUE];
    [self.mArryLocation sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]; //sort arry

    [self.mapVw addAnnotations:[self createAnnotations]];

    [self.tbleVwCoffeeShop reloadData];
}

#pragma mark - UITable View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   return [self.mArryLocation count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"coffee";
    CustomCoffeeShopInfoCell *cell = (CustomCoffeeShopInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    LocationInfo *objLocation = [self.mArryLocation objectAtIndex:indexPath.row];

    [cell insertDataInTableView:objLocation withTag:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [searchBarCoffee removeFromSuperview];
    self.navigationItem.rightBarButtonItem = barbuttonSearch;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapVwController = [storyBoard instantiateViewControllerWithIdentifier:@"MapVC"];
    mapVwController.objLocation = [self.mArryLocation objectAtIndex:indexPath.row];
    mapVwController.cordinateCurrentLocation = currentLocation;
    [self.navigationController pushViewController:mapVwController animated:YES];
}


@end
