//
//  CoreLocationUseCase.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/2/24.
//

import Foundation
import RxSwift

final class CoreLocationUseCase {
    
    private let busStopInfoRepository: BusStopInfoRepository
    private let locationService: LocationService
    
    init(
        busStopInfoRepository: BusStopInfoRepository,
        locationService: LocationService
    ) {
        self.busStopInfoRepository = busStopInfoRepository
        self.locationService = locationService
    }
    
    func getNearByStop() -> Observable<(BusStopInfoResponse, String)> {
        locationService.requestAuthorize()
        return locationService.locationResponse
            .withUnretained(self)
            .map { useCase, status in
                var response: BusStopInfoResponse
                var distance = ""
                let requestMessage = "주변 정류장을 확인하려면 위치 정보를 동의해주세요."
                let errorMessage = "오류가 발생했습니다. 관리자에게 문의해주세요."
                let defaultLocation: (longitude: Double, latitude: Double) =
                (126.979620, 37.570028)
                
                switch status {
                    case .authorized(let location):
                        print(#function, location)
                        (response, distance) = useCase.busStopInfoRepository
                            .getNearByStopInfo(startPointLocation: location)
                    case .notAuthorized:
                        response = .init(
                            busStopName: requestMessage,
                            busStopId: "",
                            direction: "",
                            longitude: defaultLocation.longitude,
                            latitude: defaultLocation.latitude
                        )
                    case .error:
                        response = .init(
                            busStopName: errorMessage,
                            busStopId: "",
                            direction: "",
                            longitude: defaultLocation.longitude,
                            latitude: defaultLocation.latitude
                        )
                        
                }
                return (response, distance)
            }
    }
}
