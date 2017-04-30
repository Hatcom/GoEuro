//
//  RidesWebservice.swift
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation

protocol RidesWebservice {
    associatedtype Service: Webservice = Self
    
    func getRawDicts(responseHandler: @escaping ([[String: AnyHashable]]?, Error?) -> ())
}
