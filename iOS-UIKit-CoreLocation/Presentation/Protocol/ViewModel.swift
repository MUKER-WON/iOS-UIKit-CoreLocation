//
//  ViewModel.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/2/24.
//

import Foundation

protocol ViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
