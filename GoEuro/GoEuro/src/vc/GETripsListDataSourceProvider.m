//
//  GETripsListDataSourceProvider.m
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

#import "GETripsListDataSourceProvider.h"

#import "GoEuro-Swift.h"

@import CoreData;

@interface GETripsListDataSourceProvider ()
@property (nonatomic, readonly) NSFetchedResultsController* frc;
@end

@implementation GETripsListDataSourceProvider

- (instancetype)initWithFRC: (NSFetchedResultsController*)frc transportType:(GETransportType)transportType {
    if (self = [super init]) {
        _frc = frc;
        _transportType = transportType;
    }
    
    return self;
}

- (void)fetch {
    NSError* error = nil;
    
    [self.frc performFetch: &error];
    
    if (error) {DLog(@"Error during fetching: %@", error.description);}
}

+ (instancetype)trainRidesProvider {
    NSFetchRequest* trainRequest = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass([TrainRide class])];
    trainRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey: @"departureTime" ascending: YES]];
    
    NSFetchedResultsController* frc = [[NSFetchedResultsController alloc] initWithFetchRequest: trainRequest
                                                                          managedObjectContext: CoreDataManager.shared.mainContext
                                                                            sectionNameKeyPath: nil
                                                                                     cacheName: nil];
    
    return [[GETripsListDataSourceProvider alloc] initWithFRC: frc transportType: TransportType_Train];
}

+ (instancetype)planeRidesProvider {
    NSFetchRequest* planeRequest = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass([PlaneRide class])];
    planeRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey: @"departureTime" ascending: YES]];
    
    NSFetchedResultsController* frc = [[NSFetchedResultsController alloc] initWithFetchRequest: planeRequest
                                                                          managedObjectContext: CoreDataManager.shared.mainContext
                                                                            sectionNameKeyPath: nil
                                                                                     cacheName: nil];
    
    return [[GETripsListDataSourceProvider alloc] initWithFRC: frc transportType: TransportType_Plane];
}

+ (instancetype)busRidesProvider {
    NSFetchRequest* busRequest = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass([BusRide class])];
    busRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey: @"departureTime" ascending: YES]];
    
    NSFetchedResultsController* frc = [[NSFetchedResultsController alloc] initWithFetchRequest: busRequest
                                                                          managedObjectContext: CoreDataManager.shared.mainContext
                                                                            sectionNameKeyPath: nil
                                                                                     cacheName: nil];
    
    return [[GETripsListDataSourceProvider alloc] initWithFRC: frc transportType: TransportType_Bus];
}


#pragma mark - GETripsListCollectionViewCellDataSource

- (NSInteger)numberOfRowsForSection: (NSInteger)section {
    return self.frc.sections[(NSUInteger) section].numberOfObjects;
}

- (Ride*)rideForIndexPath: (NSIndexPath*)indexPath {
    return (Ride*) [self.frc objectAtIndexPath: indexPath];
}

@end
