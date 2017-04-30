//
//  Ride+ImagePath.swift
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation

extension Ride {
    var providerLogoURL: URL? {
        guard let path = providerLogoRaw else {
            printErr("empty logo path stored", logToServer: true)
            
            return nil
        }
        
        let pathWithSize = path.replacingOccurrences(of: "{size}", with: Size.smallSize.rawValue)
        
        return URL(string: pathWithSize)
    }
    
    
    private enum Size: String {
        case smallSize = "63"
    }
}
