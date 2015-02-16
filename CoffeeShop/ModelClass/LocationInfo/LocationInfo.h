//
//  LocationInfo.h
//  Babiinet
//
//  Created by FxByte on 05/09/14.
//  Copyright (c) 2014 FxByte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic) float latitute;
@property (nonatomic) float longitute;

@end
