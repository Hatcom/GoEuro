//
//  GEMainViewController.m
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

#import "GEMainViewController.h"
#import "GoEuro-Swift.h"
#import "GETripsListDataSourceProvider.h"
#import "GERidesListCollectionViewCell.h"


@interface GEMainViewController () <UICollectionViewDataSource, SegmentedChooserViewDelegate, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet SegmentedChooserView *segmentedChooser;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) TransportEntityService* entityService;

@property (nonatomic) GETripsListDataSourceProvider* trainRidesProvider;
@property (nonatomic) GETripsListDataSourceProvider* busRidesProvider;
@property (nonatomic) GETripsListDataSourceProvider* planeRidesProvider;
@end

@implementation GEMainViewController

static NSString* const kRideSourceCellId = @"kRideSourceCellId";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.segmentedChooser.delegate = self;
	[self.segmentedChooser selectWithRatio: 0.0f];

	self.entityService = [TransportEntityService new];
    
	self.trainRidesProvider = [GETripsListDataSourceProvider trainRidesProvider];
	self.busRidesProvider = [GETripsListDataSourceProvider busRidesProvider];
	self.planeRidesProvider = [GETripsListDataSourceProvider planeRidesProvider];

	[self fetchAllEntities];

	[self updateAllEntities];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
	layout.itemSize = self.collectionView.bounds.size;
}

- (void)fetchAllEntities {
	BOOL allSetUp = self.trainRidesProvider != nil && self.busRidesProvider != nil && self.planeRidesProvider != nil;

	NSParameterAssert(allSetUp);

	if (!allSetUp) {return;}

	for (GETripsListDataSourceProvider* provider in @[self.trainRidesProvider, self.busRidesProvider, self.planeRidesProvider]) {
		[provider fetch];
	}
}

- (void)updateAllEntities {
	NSParameterAssert(self.entityService != nil);

	[self.entityService updateBusRidesWithCompletion: ^ (NSError* error, BOOL hasChanges) {
		[self ridesUpdated: hasChanges forProvider: self.busRidesProvider error: error];
	}];

	[self.entityService updatePlaneRidesWithCompletion: ^ (NSError* error, BOOL hasChanges) {
		[self ridesUpdated: hasChanges forProvider: self.planeRidesProvider error: error];
	}];

	[self.entityService updateTrainRidesWithCompletion: ^ (NSError* error, BOOL hasChanges) {
		[self ridesUpdated: hasChanges forProvider: self.trainRidesProvider error: error];
	}];
}

- (void)ridesUpdated:(BOOL)updated forProvider: (GETripsListDataSourceProvider*)provider error: (NSError*)error {
	if (error) {
		DLog(@"Error during update: %@", error.description);
	} else {
		if (updated) {
			dispatch_async(dispatch_get_main_queue(), ^ {
				[provider fetch];

				[self.collectionView reloadItemsAtIndexPaths: @[[NSIndexPath indexPathForRow: provider.transportType inSection: 0]]];
			});
		}
	}
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView: (UICollectionView*)collectionView numberOfItemsInSection: (NSInteger)section {
    return TransportType_Last + 1;
}

- (UICollectionViewCell*)collectionView: (UICollectionView*)collectionView cellForItemAtIndexPath: (NSIndexPath*)indexPath {
	GERidesListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: kRideSourceCellId forIndexPath: indexPath];

	switch ((GETransportType) indexPath.row) {
		case TransportType_Train:
			[cell chargeWithSource: self.trainRidesProvider];
			break;
		case TransportType_Bus:
			[cell chargeWithSource: self.busRidesProvider];
			break;
		case TransportType_Plane:
			[cell chargeWithSource: self.planeRidesProvider];
			break;
	}

    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll: (UIScrollView*)scrollView {
    CGFloat ratio = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    
    [self.segmentedChooser selectWithRatio: ratio];
}


#pragma mark - SegmentedChooserViewDelegate

- (void)segmentSelected: (NSInteger)idx {
	[self.collectionView selectItemAtIndexPath: [NSIndexPath indexPathForRow: idx inSection: 0]
									  animated: YES
								scrollPosition: UICollectionViewScrollPositionCenteredHorizontally];
}

@end
