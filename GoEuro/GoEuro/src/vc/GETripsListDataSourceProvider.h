//
//  GETripsListDataSourceProvider.h
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GERidesListCollectionViewCell.h"

typedef NS_ENUM(NSInteger, GETransportType) {
    TransportType_Train = 0,
    TransportType_Bus,
    TransportType_Plane,
    
    TransportType_Last = TransportType_Plane
};

@interface GETripsListDataSourceProvider : NSObject <GERidesListCollectionViewCellSource>
@property (nonatomic, readonly) GETransportType transportType;

- (void)fetch;

+ (instancetype)trainRidesProvider;
+ (instancetype)busRidesProvider;
+ (instancetype)planeRidesProvider;
@end
