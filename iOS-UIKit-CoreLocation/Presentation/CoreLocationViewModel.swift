//
//  CoreLocationViewModel.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CoreLocationViewModel: ViewModel {
    
    private let useCase: CoreLocationUseCase
    private let disposeBag = DisposeBag()
    
    init(useCase: CoreLocationUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            selectedBusStopInfo: .init(),
            nearStopList: .init()
        )
        
        input.informationViewTapEvent
            .subscribe(
                onNext: { _ in
                    guard let url = URL(string: UIApplication.openSettingsURLString)
                    else { return }
                    UIApplication.shared.open(url)
                }
            )
            .disposed(by: disposeBag)
        
        useCase.getNearByStop()
            .bind(to: output.selectedBusStopInfo)
            .disposed(by: disposeBag)
        return output
    }
}

extension CoreLocationViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let informationViewTapEvent: Observable<Void>
        let selectedBusStopId: Observable<String>
        let locationChangeEvent: Observable<(ClosedRange<Double>, ClosedRange<Double>)>
    }
    
    struct Output {
        let selectedBusStopInfo: PublishSubject<(BusStopInfoResponse, String)>
        let nearStopList: PublishSubject<[BusStopInfoResponse]>
    }
}
