//
//  RideParser.swift
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation
import CoreData


protocol RideParser: class {
    associatedtype TypedRide: Ride
    
    func saveNewRides(fromDicts stampPackDicts: [[String: Any]]) throws -> Bool
}

extension RideParser {
    // returns flag, indicating if anything was changed
    func saveNewRides(fromDicts rideDicts: [[String: Any]]) throws -> Bool {
        var oldRides = Ride.ge_findAll() as? [TypedRide]
        
        var needToRefresh = false
        
        for stampPackDict in rideDicts {
            guard let rideId = stampPackDict["id"] as? Int else {
                printErr("no ride id provided", logToServer: true)
                
                continue
            }
            
            func getValue<T:Hashable>(for key: String) -> T? {
                guard let value = stampPackDict[key] as? T else {
                    printErr("no \(key) provided for ride \(rideId)", logToServer: true)
                    
                    return nil
                }
                
                return value
            }
            
            let updatedRide: TypedRide
            
            if let _oldRides = oldRides, let oldRideIdx = (_oldRides.index{ $0.id == Int64(rideId) }) {
                updatedRide = oldRides!.remove(at: oldRideIdx)
            } else {
                updatedRide = TypedRide.ge_object(withUniqueAttribute: "id", value: NSNumber(value: rideId))
            }
            
            updatedRide.arrivalTime = getValue(for: "arrival_time")
            
            updatedRide.departureTime = getValue(for: "departure_time")
            
            if let numberOfStops: Int = getValue(for: "number_of_stops") {
                updatedRide.numberOfStops = Int16(numberOfStops)
            }
            
            if let priceInEuros: Float = getValue(for: "price_in_euros") {
                let newPrice = NSDecimalNumber(value: Int(priceInEuros * 100)).dividing(by: NSDecimalNumber(value: 100))
                
                updatedRide.priceInEuros = newPrice
            } else
                // FIXME: price is String for flights
                if let priceInEuros: String = getValue(for: "price_in_euros") {
                    let newPrice = NSDecimalNumber(string: priceInEuros)
                    
                    updatedRide.priceInEuros = newPrice
            }
            
            updatedRide.providerLogoRaw = getValue(for: "provider_logo")
            
            if updatedRide.hasPersistentChangedValues {
                needToRefresh = true
            }
        }
        
        if let oldRides = oldRides, oldRides.count > 0 {
            CoreDataManager.shared.removeObjects(oldRides)
            needToRefresh = true
        }
        
        if needToRefresh {
            try CoreDataManager.shared.mainContext.save()
        }
        
        return needToRefresh
    }
}
