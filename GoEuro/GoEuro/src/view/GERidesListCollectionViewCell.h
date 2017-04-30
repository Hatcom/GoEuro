//
//  GERidesListCollectionViewCell.h
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Ride;

@protocol GERidesListCollectionViewCellSource
- (NSInteger)numberOfRowsForSection: (NSInteger)section;
- (Ride*)rideForIndexPath: (NSIndexPath*)indexPath;
@end


@interface GERidesListCollectionViewCell : UICollectionViewCell
- (void)chargeWithSource: (id <GERidesListCollectionViewCellSource>)source;
@end
