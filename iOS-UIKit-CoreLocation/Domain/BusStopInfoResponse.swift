//
//  BusStopInfoResponse.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/2/24.
//

import Foundation
import CoreLocation

struct BusStopInfoResponse: Hashable, Codable {
    
    let busStopName: String
    let busStopId: String
    let direction: String
    let longitude: Double
    let latitude: Double
    
    init(
        busStopName: String,
        busStopId: String,
        direction: String,
        longitude: Double,
        latitude: Double
    ) {
        self.busStopName = busStopName
        self.busStopId = busStopId
        self.direction = direction
        self.longitude = longitude
        self.latitude = latitude
    }
}

extension BusStopInfoResponse {
    
    var location: CLLocation {
        .init(
            latitude: latitude,
            longitude: longitude
        )
    }
}
