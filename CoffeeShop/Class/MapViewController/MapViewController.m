//
//  MapViewController.m
//  CoffeeShop
//
//  Created by GrepRuby on 06/02/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

#import "MapViewController.h"
#import "MapView.h"

@interface MapViewController () {

    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
    MapView* googleMapView;
}

@end

@implementation MapViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    [self mapLocationShow];
    self.mapVw.userInteractionEnabled = YES;
    self.navigationController.navigationBar.translucent = NO;

    self.lblAddress.text = self.objLocation.address;
    self.lblDistance.text = [NSString stringWithFormat:@"%@ mtr", self.objLocation.distance];
    self.lblName.text = self.objLocation.name;

    self.title = @"Map";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];

        // [self handleRoutePressed:nil];

}

- (void)googleMapView {

    CLLocationCoordinate2D coordinate2d;
    coordinate2d.latitude = self.objLocation.latitute;
    coordinate2d.longitude = self.objLocation.longitute;

    if (googleMapView == nil) {
        googleMapView = [[MapView alloc] initWithFrame:
                         CGRectMake(0, 50, self.view.frame.size.width, self.mapVw.frame.size.height)];

        [self.view addSubview:googleMapView];
        NSLog(@"%f %f %f %f",self.cordinateCurrentLocation.latitude, self.cordinateCurrentLocation.longitude, coordinate2d.latitude, coordinate2d.longitude);
        [googleMapView showRouteFrom:self.cordinateCurrentLocation to:coordinate2d];
    } else {
        [googleMapView setHidden:NO];
    }
}

- (IBAction)segmentTapped:(id)sender {

    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:

            [self.mapVw setHidden:NO];
            [googleMapView setHidden:YES];

            break;
        case 1:

            [self googleMapView];
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 3000, 3000);
    [self.mapVw setRegion:[self.mapVw regionThatFits:region] animated:YES];
}

- (void)mapLocationShow {

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.subtitle = self.objLocation.address;
    annotation.title = self.objLocation.name;

    CLLocationCoordinate2D coordinate2d;
    coordinate2d.latitude = self.objLocation.latitute;
    coordinate2d.longitude = self.objLocation.longitute;
    annotation.coordinate = coordinate2d;
    [self.mapVw addAnnotations:@[annotation]];

    self.mapVw.zoomEnabled = YES;
    self.mapVw.showsUserLocation = YES;
}

- (IBAction)handleRoutePressed:(id)sender {

        // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
        // Start at our current location

    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:self.cordinateCurrentLocation addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];

    [directionsRequest setSource:source];
        // Make the destination
    CLLocationCoordinate2D destCoordinate2d;
    destCoordinate2d.latitude = self.objLocation.latitute;
    destCoordinate2d.longitude = self.objLocation.longitute;

    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destCoordinate2d addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];

    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {

            // Now handle the result
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }

            // So there wasn't an error - let's plot those routes
        _currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
    }];
}

#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route {

    if(_routeOverlay) {
        [self.mapVw removeOverlay:_routeOverlay];
    }

        // Update the ivar
    _routeOverlay = route.polyline;

        // Add it to the map
    [self.mapVw addOverlay:_routeOverlay];
    
}

- (MKPolylineView*)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay {

    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth = 5;
    overlayView.strokeColor = [UIColor greenColor];
    overlayView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1f];
    return overlayView;
    
}

@end
