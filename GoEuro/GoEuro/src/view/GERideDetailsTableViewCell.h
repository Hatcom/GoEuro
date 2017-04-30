//
//  GERideDetailsTableViewCell.h
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Ride;

@interface GERideDetailsTableViewCell : UITableViewCell

- (void)chargeWithRide: (Ride*)ride;

@end
