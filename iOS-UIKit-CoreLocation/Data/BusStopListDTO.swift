//
//  BusStopListDTO.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/2/24.
//

import Foundation

struct BusStopListDTO: Codable {
    
    let description: Description
    let data: [BusStopInfo]
    
    enum CodingKeys: String, CodingKey {
        
        case description = "DESCRIPTION"
        case data = "DATA"
    }
    
    // MARK: - BusStopInfo
    
    struct BusStopInfo: Codable {
        
        let stopNm, ycode, stopNo, xcode, nxtStn: String
        let stopType: String
        let nodeID: String
        
        enum CodingKeys: String, CodingKey {
            
            case stopNm = "stop_mn"
            case ycode
            case stopNo = "stop_no"
            case xcode
            case nxtStn
            case stopType = "stop_type"
            case nodeID = "node_id"
        }
    }
    
    // MARK: - Description
    
    struct Description: Codable {
        
        let stopType, ycode, stopNm, nodeID: String
        let stopNo, xcode, nxtStn: String
        
        enum CodingKeys: String, CodingKey {
            
            case stopType = "STOP_TYPE"
            case ycode = "YCODE"
            case stopNm = "STOP_NM"
            case nodeID = "NODE_ID"
            case stopNo = "STOP_NO"
            case xcode = "XCODE"
            case nxtStn = "NXT_STN"
        }
    }
}

extension BusStopListDTO {
    
    var toDomain: [BusStopInfoResponse] {
        data.compactMap { busStopInfo in
            .init(
                busStopName: busStopInfo.stopNm,
                busStopId: busStopInfo.stopNo,
                direction: busStopInfo.nxtStn,
                longitude: Double(busStopInfo.xcode) ?? 0.0,
                latitude: Double(busStopInfo.ycode) ?? 0.0
            )
        }
    }
}


