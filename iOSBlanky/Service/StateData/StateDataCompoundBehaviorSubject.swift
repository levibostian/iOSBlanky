//
//  StateDataCompoundBehaviorSubject.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/24/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift

/**
 * A wrapper around [BehaviorSubject] and [StateData] to give a "compound" feature to [StateData] it did not have previously.
 *
 * [BehaviorSubject]s are great in that you can grab the very last value that was passed into it. This is a great type of [Observable] since you can always get the very last value that was emitted. This works great with [StateData] so you can always know the state of data by grabbing it's last value.
 *
 * Maintaining the state of an instance of [StateData] is a pain. [StateData] has a state (loading, empty, data) but it also has some other states built on top of it temporarily such as if an error occurs or if data is currently being fetched. The UI cares about all of these states [StateData] could be in to display the best message to the user as possible. However, when an error occurs, for example, we need to pass the error to [StateData] to be handled by the UI. *Someone at some point needs to handle this error. We don't want it to go ignored*. What if we call [BehaviorSubject.onNext] with an instance of [StateData] with an error in it? That is unsafe. We could call [BehaviorSubject.onNext] shortly after with an instance of [StateData] without an error. **That error has now gone unseen!**
 *
 * Another use case to think about is fetching data. You could call [BehaviorSubject.onNext] with an instance of [StateData] saying data is fetching then shortly after an error occurs, the database fields changed, database rows were deleted, etc. and we will call [BehaviorSubject.onNext] again with another instance of [StateData]. Well, we need to keep track somehow of the fetching status of data. That is a pain to maintain and make sure it is accurate. It's also error prone.
 *
 * With that in mind, we "compound" errors and status of fetching data to the last instance of [StateData] found inside of an instance of [BehaviorSubject].
 */
class StateDataCompoundBehaviorSubject<DataType: Any> {
    
    fileprivate var stateData: StateData<DataType> = StateData()
    let subject: BehaviorSubject<StateData<DataType>>!
    
    convenience init() {
        self.init(stateData: StateData(isLoading: false, isEmptyData: false, data: nil))
    }
    
    init(stateData: StateData<DataType>) {
        self.stateData = stateData
        subject = BehaviorSubject(value: stateData)
    }
    
    func hasValue() -> Bool {
        return subject.hasValue()
    }
    
    /**
     * The status of data is loading.
     */
    func onNextIsLoading() {
        stateData = StateData(isLoading: true)
        subject.onNext(stateData)
    }
    
    /**
     * The status of data is empty (optionally fetching new fresh data as well).
     */
    func onNextEmpty(isFetchingFreshData: Bool = false) {
        stateData = StateData(isEmptyData: true)
        if isFetchingFreshData {
            stateData = stateData.fetchingFreshData()
            onNextCompoundDoneFetchingFreshData()
        }
        subject.onNext(stateData)
    }
    
    /**
     * The status of data is data (optionally fetching new fresh data as well).
     */
    func onNextData(data: DataType, isFetchingFreshData: Bool = false) {
        stateData = StateData(data: data)
        if isFetchingFreshData {
            stateData = stateData.fetchingFreshData()
            onNextCompoundFetchingFreshData()
        }
        subject.onNext(stateData)
    }
    
    /**
     * An error occurred with this data.
     */
    func onNextCompoundError(error: Error) {
        // We don't want a user to have to look at a loading screen after an error occurred therefore, we want to show them an empty view and an error. That's better then an infinite loading screen!
        if subject.hasValue() {
            let subjectValue = try! subject.value()
            let dataIsInLoadingState = subjectValue.isLoading
            if dataIsInLoadingState { stateData = StateData(isEmptyData: true) }
        }
        subject.onNext(stateData.errorOccurred(error))
    }
    
    /**
     * Fresh data is being fetched. Compound that status to the existing [StateData] instance.
     */
    func onNextCompoundFetchingFreshData() {
        subject.onNext(stateData.fetchingFreshData())
    }
    
    /**
     * Fresh data is done being fetched. Compound that status to the existing [StateData] instance.
     */
    func onNextCompoundDoneFetchingFreshData() {
        subject.onNext(stateData.doneFetchingFreshData())
    }
    
    /**
     * Get a [BehaviorSubject] as an [Observable]. Convenient as you more then likely do not need to care about the extra functionality of [BehaviorSubject] when you simply want to observe data changes.
     */
    func asObservable() -> Observable<StateData<DataType>> {
        return subject
    }
    
}
