//
//  GERideDetailsTableViewCell.m
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "GERideDetailsTableViewCell.h"

#import "GoEuro-Swift.h"

@interface GERideDetailsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStopsLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation GERideDetailsTableViewCell

- (void)chargeWithRide: (Ride*)ride {
	if (ride.numberOfStops == 0) {
		self.numberOfStopsLabel.text = @"Direct";
		self.numberOfStopsLabel.textColor = [UIColor colorWithRed: 0.19 green: 0.67 blue: 0.31 alpha: 1.00];
	} else {
		self.numberOfStopsLabel.text = [NSString stringWithFormat: @"%i change", ride.numberOfStops];
		self.numberOfStopsLabel.textColor = UIColor.darkGrayColor;
	}

	self.costLabel.text = [NSString stringWithFormat: @"%.02f €", ride.priceInEuros.floatValue];
	self.scheduleLabel.text = [NSString stringWithFormat: @"%@ - %@", ride.departureTime, ride.arrivalTime];
	self.durationLabel.text = [self getDurationTextBetween: ride.departureTime and: ride.arrivalTime];

	[self.logoImageView sd_setImageWithURL: ride.providerLogoURL placeholderImage: nil];
}

- (NSString*)getDurationTextBetween: (NSString*)departureTimeString and: (NSString*)arrivalTimeString {
	NSDateFormatter* dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = @"HH:mm";

	NSDate* departureTime = [dateFormatter dateFromString: departureTimeString];
	NSDate* arrivalTime = [dateFormatter dateFromString: arrivalTimeString];

	NSTimeInterval duration = [arrivalTime timeIntervalSinceDate: departureTime];

	NSInteger interval = (NSInteger) duration;
	int minutes = (interval / 60) % 60;
	int hours = (interval / 3600);

	return [NSString stringWithFormat: @"%02i:%02ih", hours, minutes];
}

@end
