//
//  DataSource.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// Used to set how old data can be before it is too old and needs new data fetched.
/// Example: AllowedAgeOfDate(unit: 5, component: NSCalendar.Unit.minute) to represent 5 minutes old is the maximum amount of time the data can be before it is known as too old.
struct AllowedAgeOfDate {
    var unit: Int
    var component: NSCalendar.Unit
}

protocol DataSource {
    associatedtype DataTypeAssociatedType: Any
    /// Get an observable that gets the current state of data and all future states.
    func getObservableState() -> Observable<StateData<DataTypeAssociatedType>>
}
