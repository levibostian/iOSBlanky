//
//  LocalDataSource.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/28/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// DataSource that is meant for data to be read/write on local device only such as UserDefaults. Not meant to communicate with a network call for example.
protocol LocalDataSource: DataSource {
    /// Save the data to whatever storage method DataSource chooses.
    func saveData(_ data: DataTypeAssociatedType?)
    /// Used by BaseLocalDataSource to observe data and keep track of state.
    func observeLocalData() -> Observable<DataTypeAssociatedType>
    /// DataType determines if data is empty or not. Because data can be of `Any` type, the DataType must determine when data is empty or not.
    func isDataEmpty(_ data: DataTypeAssociatedType) -> Bool
    /// Get data if exists instead of observing it. Great for one off getting data.
    func getValue() -> DataTypeAssociatedType?
}

class BaseLocalDataSource<DataType: Any>: LocalDataSource {
    
    typealias DataTypeAssociatedType = DataType
    
    private var stateOfDate: StateDataCompoundBehaviorSubject<DataType>?
    
    fileprivate var compositeDisposable = CompositeDisposable()
    
    func getObservableState() -> Observable<StateData<DataType>> {
        if stateOfDate == nil {
            stateOfDate = StateDataCompoundBehaviorSubject()
            
            _ = self.compositeDisposable.insert(
                self.observeLocalData()
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribe(onNext: { (cachedData: DataType) in
                        if self.isDataEmpty(cachedData) {
                            self.stateOfDate?.onNextEmpty()
                        } else {
                            self.stateOfDate?.onNextData(data: cachedData)
                        }
                    }, onError: { (error: Error) in
                        self.stateOfDate?.onNextCompoundError(error: error)
                    })
            )
        }
        return stateOfDate!.asObservable()
    }
    
    func saveData(_ data: DataType?) {
        fatalError("You forgot to override.")
    }
    
    func observeLocalData() -> Observable<DataType> {
        fatalError("You forgot to override.")
    }
    
    func isDataEmpty(_ data: DataType) -> Bool {
        fatalError("You forgot to override.")
    }
    
    func getValue() -> DataType? {
        fatalError("You forgot to override.")
    }
    
}
