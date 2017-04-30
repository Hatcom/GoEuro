//
//  TrainWebservice.swift
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import UIKit

class TrainWebservice: Webservice, RidesWebservice {
    func getRawDicts(responseHandler: @escaping ([[String: AnyHashable]]?, Error?) -> ()) {
        let request = URLRequest.defaultGETRequest(forPath: "3zmcy")
        
        urlSession.dataTask(with: request) { data, response, error in
            self.parseResponse(data, error: error, completion: responseHandler)
        }.resume()
    }
}
