//
//  LocationResponse.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/2/24.
//

import Foundation
import CoreLocation

enum LocationResponse {
    
    case notAuthorized
    case error
    case authorized(CLLocation)
}
