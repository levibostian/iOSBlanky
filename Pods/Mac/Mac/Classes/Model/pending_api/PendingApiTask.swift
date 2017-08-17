//
//  PendingApiTask.swift
//  Pods
//
//  Created by Levi Bostian on 4/3/17.
//
//

import Foundation
import Alamofire
import RxSwift
import RealmSwift 

public protocol PendingApiTask {
    
    func queryForExistingTask(realm: Realm) -> PendingApiTask?
    
    func canRunTask(realm: Realm) -> Bool
    
    var createdAt: Date { get set }
    var manuallyRunTask: Bool { get set }
    
    func getOfflineModelTaskRepresents(realm: Realm) -> OfflineCapableModel    
    
    func performApiCall(realm: Realm) -> Single<Any?> // call upload or download calls in ApiNetworkingService.
    
    //func getApiErrorVo<ERROR_VO: ErrorResponseVo>() -> ERROR_VO // I could not get generic to work through whole lib. I had a few cases where I could not get it to inherit the type so having the child of PendingApiTask decide what object ObjectMapper maps to works for now.
    func getApiErrorMessage(rawApiResponse: Any?) -> String // take raw JSON error response and turn into some kind of string to represent the error for the app user to understand.
    
    func processApiResponse(realm: Realm, rawApiResponse: Any?) // take raw JSON response from API and do what want with it such as ObjectMapper.
    
}
