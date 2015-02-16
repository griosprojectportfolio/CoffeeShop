//
//  CustomCoffeeShopInfoCell.h
//  CoffeeShop
//
//  Created by GrepRuby on 06/02/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationInfo.h"

@interface CustomCoffeeShopInfoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblDistance;
@property (nonatomic, weak) IBOutlet UILabel *lblAddress;
@property (nonatomic, weak) IBOutlet UILabel *lblSideBar;
@property (nonatomic, weak) IBOutlet UIImageView *imgVwCoffee;

- (void)insertDataInTableView:(LocationInfo*)location withTag:(int)tag;

@end
