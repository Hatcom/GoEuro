//
//  GERidesListCollectionViewCell.m
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

#import "GERidesListCollectionViewCell.h"
#import "GoEuro-Swift.h"
#import "GERideDetailsTableViewCell.h"

@interface GERidesListCollectionViewCell () <UITableViewDataSource>
@property (nonatomic) id <GERidesListCollectionViewCellSource> source;

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@end

@implementation GERidesListCollectionViewCell

static NSString* const kRideDetailsCellId = @"kRideDetailsCellId";

- (void)chargeWithSource: (id <GERidesListCollectionViewCellSource>)source {
	self.source = source;

	[self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView: (UITableView*)tableView numberOfRowsInSection: (NSInteger)section {
	return [self.source numberOfRowsForSection: section];
}

- (UITableViewCell*)tableView: (UITableView*)tableView cellForRowAtIndexPath: (NSIndexPath*)indexPath {
	GERideDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: kRideDetailsCellId forIndexPath: indexPath];

	Ride* ride = [self.source rideForIndexPath: indexPath];

	[cell chargeWithRide: ride];

	return cell;
}

@end
