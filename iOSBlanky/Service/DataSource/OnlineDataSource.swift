//
//  OnlineDataSource.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/28/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol OnlineDataSource: DataSource {
    associatedtype ResultDataTypeAssociatedType: Any
    associatedtype GetDataRequirementsAssociatedType: GetDataRequirements
    associatedtype RequestDataTypeAssociatedType: Any
    
    /// Used to set how old data can be in the app for this certain type of data before it is considered too old and new data should be fetched. This can be overriden by a ViewModel using it.
    var allowedAgeOfData: AllowedAgeOfDate { get set }
    /// Perform a one time sync of the data. Sync will check the last updated date and it's own default allowed age of data to determine if it should fetch fresh data or not. You may override this behavior with `force` and `overrideMinimumAllowedAgeOfDate` params.
    func sync(force: Bool, getDataRequirements: GetDataRequirementsAssociatedType) -> Completable
    /// Get an observable that gets the current state of data and all future states.
    func getObservableState() -> Observable<StateData<ResultDataTypeAssociatedType>>
    /// Call to set or change the requirements for how to load data. Once set, the data source will update the state of data. No need to call `getObservableState()` again as it will be updated automatically for you.
    func setDataQueryRequirements(_ requirements: GetDataRequirementsAssociatedType)
    /// DataSource does what it needs in order to fetch fresh data. Probably call network API.
    func fetchFreshDataOrFail(requirements: GetDataRequirementsAssociatedType) -> Single<RequestDataTypeAssociatedType>
    /// Save the data to whatever storage method DataSource chooses.
    func saveData(_ data: RequestDataTypeAssociatedType) -> Completable
    /// Get existing cached data saved to the device if it exists. Return nil is data does not exist or is empty.
    func getCachedData(requirements: GetDataRequirementsAssociatedType) -> Observable<ResultDataTypeAssociatedType>
    /// DataType determines if data is empty or not. Because data can be of `Any` type, the DataType must determine when data is empty or not.
    func isDataEmpty(_ data: ResultDataTypeAssociatedType) -> Bool
}

/// A simple VO object. Using init() to set whatever data you need inside.
/// Make sure to add:
/// var description: String
protocol GetDataRequirements: CustomStringConvertible {
}

class BaseOnlineDataSource<ResultDataType: Any, GetDataRequirementsType: GetDataRequirements, RequestDataType: Any>: OnlineDataSource {
    
    fileprivate var stateOfDataGetDataRequirements: GetDataRequirementsType?
    var allowedAgeOfData: AllowedAgeOfDate = AllowedAgeOfDate(unit: 5, component: NSCalendar.Unit.minute)
    
    fileprivate var compositeDisposable = CompositeDisposable()
    
    typealias ResultDataTypeAssociatedType = ResultDataType
    typealias GetDataRequirementsAssociatedType = GetDataRequirementsType
    typealias RequestDataTypeAssociatedType = RequestDataType
    
    private var stateOfDate: StateDataCompoundBehaviorSubject<ResultDataType>?
    
    var moyaProvider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: MoyaPluginProvider.getPlugins(getNetworkActivityPlugin: true))
    
    func setDataQueryRequirements(_ requirements: GetDataRequirementsType) {
        self.stateOfDataGetDataRequirements = requirements
        
        beginObservingStateOfData()
    }
    
    fileprivate func beginObservingStateOfData() {
        guard let getDataRequirements = self.stateOfDataGetDataRequirements else { return }
        
        self.compositeDisposable.dispose()
        
        func initializeObservingCachedData() {
            _ = self.compositeDisposable.insert(
                self.getCachedData(requirements: getDataRequirements)
                    //.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)) // causes issue where realm is not created on ui thread but data is read from that thread so it's off.
                    .subscribe(onNext: { (cachedData: ResultDataType) in
                        let needsToFetchFreshData = self.isDataTooOld(getDataRequirements: getDataRequirements)
                        
                        if self.isDataEmpty(cachedData) {
                            self.stateOfDate?.onNextEmpty(isFetchingFreshData: needsToFetchFreshData)
                        } else {
                            self.stateOfDate?.onNextData(data: cachedData, isFetchingFreshData: needsToFetchFreshData)
                        }
                        
                        if needsToFetchFreshData {
                            self._sync(getDataRequirements: getDataRequirements, onComplete: {
                            }, onError: { (_: Error) in
                            })
                        }
                    }, onError: { (error: Error) in
                        self.stateOfDate?.onNextCompoundError(error: error)
                    })
            )
        }
        
        if !hasEverFetchedData(getDataRequirements: getDataRequirements) {
            self.stateOfDate?.onNextIsLoading()
            
            self._sync(getDataRequirements: getDataRequirements, onComplete: {
                initializeObservingCachedData()
            }, onError: { (_: Error) in
                // Note: Even if there is an error, we want to start observing cached data so we can transition to an empty state instead of infinite loading state for the UI for the user.
                initializeObservingCachedData()
            })
        } else {
            initializeObservingCachedData()
        }
    }
    
    func getObservableState() -> Observable<StateData<ResultDataType>> {
        if stateOfDate == nil {
            stateOfDate = StateDataCompoundBehaviorSubject()
        }
        beginObservingStateOfData()
        
        return stateOfDate!.asObservable().do(onDispose: {
            self.compositeDisposable.dispose()
        })
    }
    
    func sync(force: Bool, getDataRequirements: GetDataRequirementsType) -> Completable {
        if force || self.isDataTooOld(getDataRequirements: getDataRequirements) {
            return Completable.create(subscribe: { (observer) -> Disposable in
                self._sync(getDataRequirements: getDataRequirements, onComplete: {
                    observer(CompletableEvent.completed)
                }, onError: { (error: Error) in
                    observer(CompletableEvent.error(error))
                })
                return Disposables.create()
            })//.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        } else {
            return Completable.empty()
        }
    }
    
    fileprivate func _sync(getDataRequirements: GetDataRequirementsType, onComplete: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        _ = self.fetchFreshDataOrFail(requirements: getDataRequirements)
            //.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe({ (event) in
                switch event {
                case .success(let freshData):
                    self.updateLastTimeFreshDataFetched(getDataRequirements: getDataRequirements)
                    _ = self.saveData(freshData)
                        //.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                        .subscribe(onCompleted: {
                            // No need to update the subject saying new data is available because anyone calling getObservableData should be getting an observable that is reactive anyway so when data is saved above, an update for the data will trigger already.
                            onComplete()
                        }, onError: { (error: Error) in
                            self.stateOfDate?.onNextCompoundError(error: error)
                            onError(error)
                        })
                case .error(let error):
                    // Note: We need to set the last updated time here or else we could run an infinite loop if the api call errors.
                    self.updateLastTimeFreshDataFetched(getDataRequirements: getDataRequirements)
                    self.stateOfDate?.onNextCompoundError(error: error)
                    onError(error)
                }
            })
    }
    
    fileprivate func getDateFromAllowedAgeOfDate(_ allowedAgeOfDate: AllowedAgeOfDate) -> Date {
        return NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.date(byAdding: allowedAgeOfDate.component, value: -allowedAgeOfDate.unit, to: Date(), options: NSCalendar.Options())!
    }
    
    fileprivate func isDataTooOld(getDataRequirements: GetDataRequirementsType) -> Bool {
        guard hasEverFetchedData(getDataRequirements: getDataRequirements) else { return true }
        
        return isDataOlderThan(getDateFromAllowedAgeOfDate(allowedAgeOfData), getDataRequirements: getDataRequirements)
    }
    
    fileprivate func getLastTimeFetchedFreshData(getDataRequirements: GetDataRequirements) -> Date? {
        let lastFetchedTime = UserDefaults.standard.double(forKey: getDataRequirements.description)
        guard lastFetchedTime > 0 else { return nil }
        
        return Date(timeIntervalSince1970: lastFetchedTime)
    }
    
    fileprivate func updateLastTimeFreshDataFetched(getDataRequirements: GetDataRequirementsType) {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: getDataRequirements.description)
    }
    
    fileprivate func hasEverFetchedData(getDataRequirements: GetDataRequirements) -> Bool {
        return getLastTimeFetchedFreshData(getDataRequirements: getDataRequirements) != nil
    }
    
    fileprivate func isDataOlderThan(_ date: Date, getDataRequirements: GetDataRequirements) -> Bool {
        guard let lastTimeDataFetched = getLastTimeFetchedFreshData(getDataRequirements: getDataRequirements) else { return true }
        
        return lastTimeDataFetched < date
    }
    
    func fetchFreshDataOrFail(requirements: GetDataRequirementsType) -> PrimitiveSequence<SingleTrait, RequestDataType> {
        fatalError("You forgot to override.")
    }
    
    func saveData(_ data: RequestDataType) -> Completable {
        fatalError("You forgot to override.")
    }
    
    func getCachedData(requirements: GetDataRequirementsType) -> Observable<ResultDataType> {
        fatalError("You forgot to override.")
    }
    
    func isDataEmpty(_ data: ResultDataType) -> Bool {
        fatalError("You forgot to override.")
    }
    
}
