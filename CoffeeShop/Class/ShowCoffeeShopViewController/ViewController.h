//
//  ViewController.h
//  CoffeeShop
//
//  Created by GrepRuby on 06/02/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tbleVwCoffeeShop;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet MKMapView *mapVw;

@end

