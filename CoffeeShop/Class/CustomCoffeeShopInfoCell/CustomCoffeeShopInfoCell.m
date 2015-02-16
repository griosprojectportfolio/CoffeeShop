//
//  CustomCoffeeShopInfoCell.m
//  CoffeeShop
//
//  Created by GrepRuby on 06/02/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

#import "CustomCoffeeShopInfoCell.h"

@implementation CustomCoffeeShopInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)insertDataInTableView:(LocationInfo*)location withTag:(int)tag {

    self.lblName.textColor = [UIColor orangeColor];

    self.lblAddress.text = location.address;
    self.lblDistance.text = [NSString stringWithFormat:@"%@ mtr", location.distance];
    self.lblName.text = location.name;
    [self bringSubviewToFront:self.lblSideBar];
    
    if (tag%2 == 0) {

        self.lblSideBar.backgroundColor = [UIColor yellowColor];
    } else {
        self.lblSideBar.backgroundColor = [UIColor redColor];
    }


    dispatch_queue_t userImageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(userImageQueue, ^{

        NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:location.icon]];

        dispatch_async(dispatch_get_main_queue(), ^{

            self.imgVwCoffee.image = [UIImage imageWithData:image];;
        });
    });
}


@end
