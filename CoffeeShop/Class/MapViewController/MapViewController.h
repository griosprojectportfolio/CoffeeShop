//
//  MapViewController.h
//  CoffeeShop
//
//  Created by GrepRuby on 06/02/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationInfo.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapVw;

@property (nonatomic, strong) LocationInfo *objLocation;

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblDistance;
@property (nonatomic, weak) IBOutlet UILabel *lblAddress;

@property (nonatomic) CLLocationCoordinate2D cordinateCurrentLocation;

@end
