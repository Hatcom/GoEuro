//
//  TransportEntityService.swift
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit

/*
 Parsers and services separated intentionally
 */

class TransportEntityService: NSObject {
    let planeWebService = PlaneWebservice()
    let busWebService = BusWebservice()
    let trainWebService = TrainWebservice()
    
    func updatePlaneRides(completion: ((Error?, Bool) -> ())?) {
        updateRides(withService: planeWebService, parsedBy: PlaneParser(), completion: completion)
    }
    
    func updateBusRides(completion: ((Error?, Bool) -> ())?) {
        updateRides(withService: busWebService, parsedBy: BusParser(), completion: completion)
    }
    
    func updateTrainRides(completion: ((Error?, Bool) -> ())?) {
        updateRides(withService: trainWebService, parsedBy: TrainParser(), completion: completion)
    }
    
    private func updateRides<P:RideParser, S:RidesWebservice>(withService service: S, parsedBy parser: P, completion: ((Error?, Bool) -> ())?) {
        service.getRawDicts { dictionary, error in
            guard let dictionary = dictionary, error == nil else {
                completion?(error, false)
                
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let hasChanges = try parser.saveNewRides(fromDicts: dictionary)
                    completion?(nil, hasChanges)
                } catch {
                    completion?(error, false)
                }
            }
        }
    }
}
