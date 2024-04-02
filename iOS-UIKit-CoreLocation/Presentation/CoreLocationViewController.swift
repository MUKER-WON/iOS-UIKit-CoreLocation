//
//  ViewController.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import NMapsMap

class CoreLocationViewController: UIViewController {
    private let viewModel: CoreLocationViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.addCameraDelegate(delegate: self)
        return mapView
    }()
    
    private let descriptionBtn: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.configuration?.titlePadding = 10
        button.backgroundColor = .white
        button.setTitleColor(
            .black,
            for: .normal
        )
        return button
    }()
    
    init(viewModel: CoreLocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        [naverMapView, descriptionBtn].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            naverMapView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            naverMapView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            naverMapView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
            
            descriptionBtn.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            descriptionBtn.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -20
            )
        ])
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx
                    .methodInvoked(#selector(UIViewController.viewWillAppear))
                    .map { _ in },
                informationViewTapEvent: descriptionBtn.rx.tap.asObservable(),
                selectedBusStopId: .empty(),
                locationChangeEvent: .empty())
        )
        
        output.selectedBusStopInfo
            .withUnretained(self)
            .subscribe { viewController, tuple in
                let (response, distance) = tuple
                viewController.moveCamera(response: response)
                let description = "\(response.busStopName)\n\(distance)"
                viewController.descriptionBtn.setTitle(
                    description,
                    for: .normal
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func moveCamera(response: BusStopInfoResponse) {
        print(response.longitude)
        print(response.latitude)
        let cameraUpdate = NMFCameraUpdate(
            position: .init(
                .init(
                    lat: response.latitude,
                    lng: response.longitude
                ),
                zoom: 17
            )
        )
        naverMapView.moveCamera(cameraUpdate)
    }
}

extension CoreLocationViewController: NMFMapViewCameraDelegate {
    
}
