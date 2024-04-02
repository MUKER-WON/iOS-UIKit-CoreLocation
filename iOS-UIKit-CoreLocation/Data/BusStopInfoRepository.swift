//
//  BusStopInfoRepository.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/2/24.
//

import Foundation
import CoreLocation

final class BusStopInfoRepository {
    var responses: [BusStopInfoResponse] = []
    
    init() {
        fetchList()
    }
    
    func getNearByStopInfo(
        startPointLocation: CLLocation
    ) -> (BusStopInfoResponse, String) {
        let errorResponse = BusStopInfoResponse(
            busStopName: "가까운 정류장을 찾을 수 없습니다.",
            busStopId: "",
            direction: "",
            longitude: 0,
            latitude: 0
        )
        var nearByStopDistance = Int.max
        var nearByStop = responses.first ?? errorResponse
        responses.forEach { busStop in
            let distance = Int(
                CLLocation(
                    latitude: busStop.latitude,
                    longitude: busStop.longitude
                ).distance(from: startPointLocation)
            )
            if nearByStopDistance > distance {
                nearByStop = busStop
                nearByStopDistance = distance
            }
        }
        let distanceStr: String
        switch nearByStopDistance {
        case ..<1000:
            distanceStr = "\(nearByStopDistance)m"
        case Int.max:
            distanceStr = "측정거리 초과"
        default:
            distanceStr =  "\(nearByStopDistance / 1000)km"
        }
        print(#function, nearByStop)
        return (nearByStop, distanceStr)
    }
    
    // MARK: - Internal Function
    
    private func fetchList() {
        guard let url = Bundle.main.url(
            forResource: "total_stationList",
            withExtension: "json"
        ) else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            responses = try JSONDecoder()
                .decode(
                    BusStopListDTO.self,
                    from: data
                )
                .toDomain
        } catch {
            print(error.localizedDescription)
        }
    }
}
