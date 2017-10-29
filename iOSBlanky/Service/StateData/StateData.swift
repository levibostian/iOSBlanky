//
//  StateData.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation

enum StateDataOnlineDataState<DataType: Any> {
    case isLoading
    case isEmpty
    case isFetchingFreshData
    case doneFetchingFreshData(errorCausedDoneFetching: Bool)
    case dataExists(data: DataType)
    case errorFound(error: Error)
    case noState()
}

enum StateDataLocalDataState<DataType: Any> {
    case isEmpty
    case dataExists(data: DataType)
    case errorFound(error: Error)
}
/**
Data in apps are in 1 of 3 different types of state:

1. Data does not exist. It has never been obtained before.
2. It is empty. Data has been obtained before, but there is none.
3. Data exists.

This class takes in a type of data to keep state on via generic [DATA_TYPE] and it maintains the state of that data.

Along with the 3 different states data could be in, there are temporary states that data could also be in.

* An error occurred with that data.
* Fresh data is being fetched for this data. It may be updated soon.

The 3 states listed above empty, data, loading are all permanent. Data is 1 of those 3 at all times. Data has this error or fetching status temporarily until someone calls [deliver] one time and then those temporary states are deleted.

This class is used in companion with [StateDataCompoundBehaviorSubject] to maintain the state of data to deliver to someone observing.
*/
class StateData<DataType: Any> {
    
    var isLoading: Bool = false
    var isEmptyData: Bool = false
    var data: DataType?
    
    var latestError: Error?
    var isFetchingFreshData: Bool = false
    var isDoneFetchingFreshData: Bool = false
    var errorCausedDoneFetching: Bool = false
    
    init(isLoading: Bool = false, isEmptyData: Bool = false, data: DataType? = nil) {
        self.isLoading = isLoading
        self.isEmptyData = isEmptyData
        self.data = data
    }
    
    func errorOccurred(_ error: Error) -> StateData {
        self.latestError = error
        return self
    }
    
    func fetchingFreshData() -> StateData {
        self.isFetchingFreshData = true
        self.isDoneFetchingFreshData = false
        return self
    }
    
    func doneFetchingFreshData(errorCausedDoneFetching: Bool = false) -> StateData {
        self.isFetchingFreshData = false
        self.isDoneFetchingFreshData = true
        self.errorCausedDoneFetching = errorCausedDoneFetching
        return self
    }
    
    /**
     * This is usually used in the UI of an app to display data to a user.
     *
     * Using this function, you can get the state of the data as well as handle errors that may have happened with data (during fetching fresh data or reading the data off the device) or get the status of fetching fresh new data.
     *
     * Call this function when an instance of [StateData] is given to you.
     */
    func onlineDataState() -> StateDataOnlineDataState<DataType> {
        var returnStateData: StateDataOnlineDataState<DataType> = StateDataOnlineDataState.noState()
        
        if isLoading { returnStateData = StateDataOnlineDataState.isLoading }
        if isEmptyData { returnStateData = StateDataOnlineDataState.isEmpty }
        if isFetchingFreshData { returnStateData = StateDataOnlineDataState.isFetchingFreshData }
        if isDoneFetchingFreshData { returnStateData = StateDataOnlineDataState.doneFetchingFreshData(errorCausedDoneFetching: errorCausedDoneFetching) }
        if let data = data { returnStateData = StateDataOnlineDataState.dataExists(data: data) }
        if let latestError = latestError { returnStateData = StateDataOnlineDataState.errorFound(error: latestError) }
        
        resetTempData()
        
        return returnStateData
    }
    
    /**
     * This is usually used in the UI of an app to display data to a user.
     *
     * This function is used when reading state data from a local data source. Data is not loaded from an online source, so less states of the data exist.
     *
     * Call this function when an instance of [StateData] is given to you.
     */
    func localDataState() -> StateDataLocalDataState<DataType> {
        var returnStateData: StateDataLocalDataState<DataType> = StateDataLocalDataState.isEmpty
        
        if isEmptyData { returnStateData = StateDataLocalDataState.isEmpty }
        if let data = data { returnStateData = StateDataLocalDataState.dataExists(data: data) }
        if let latestError = latestError { returnStateData = StateDataLocalDataState.errorFound(error: latestError) }
        
        resetTempData()
        
        return returnStateData
    }
    
    private func resetTempData() {
        isFetchingFreshData = false
        isDoneFetchingFreshData = false
        errorCausedDoneFetching = false
        latestError = nil
    }
    
}
