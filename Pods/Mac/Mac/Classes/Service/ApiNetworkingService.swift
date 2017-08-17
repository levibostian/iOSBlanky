//
//  ApiNetworkingService.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation
import RxSwift
import Alamofire
import iOSBoilerplate

public class MimeTypeConstants {
    public static let jpeg = "image/jpeg"
    public static let png = "image/png"
}

public class ApiNetworkingService {
    
    public struct UploadMultipartFormData {
        var data: Data!
        var name: String!
    }
    
    public struct UploadFileMultipartFormData {
        var data: Data!
        var multipartFormName: String!
        var fileName: String!
        var mimeType: String!
    }
    
    fileprivate class var sessionManager: SessionManager {
        get {
            guard let alamofireConfiguration = MacConfigInstance?.macAlamofireConfig else {
                fatalError("You need to configure Mac before peforming any API calls.")
            }
            
            var sessionManager = Alamofire.SessionManager.default
            if let sessionConfiguration = alamofireConfiguration.getUrlSessionConfig() {
                sessionManager = SessionManager(configuration: sessionConfiguration)
            }
            
            if let requestAdapter = alamofireConfiguration.getRequestAdapter() {
                sessionManager.adapter = requestAdapter
            }
            
            return sessionManager
        }
    }
    
    public class func executeUploadApiCall(_ call: URLRequestConvertible, data: [UploadMultipartFormData], files: [UploadFileMultipartFormData], parseError: @escaping (Any?) -> String) -> Single<Any?> {
        return Single<Any?>.create { observer in
            clearCacheIfDev()
        
            sessionManager.upload(multipartFormData: { (multiformData) in
                for formData in data {
                    multiformData.append(formData.data, withName: formData.name)
                }
                for file in files {
                    multiformData.append(file.data, withName: file.multipartFormName, fileName: file.fileName, mimeType: file.mimeType.description)
                }
            }, with: call) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                        let responseCode = response.response!.statusCode
                        switch response.result {
                        case .success:
                            _ = determineErrorResponse(response: response, responseStatusCode: responseCode, parseError: parseError)
                                .subscribeSingle({ (responseValue) in
                                    observer(SingleEvent.success(responseValue))
                                }, onError: { (error) in
                                    observer(SingleEvent.error(error))
                                })
                        case .failure(let error):
                            responseFailureEncountered(error, observer: observer, responseCode: responseCode, response: response)
                        }
                    })
                case .failure(let error):
                    MacConfigInstance?.macErrorNotifier.errorEncountered(error: error)
                    observer(SingleEvent.error(MacAPIError.apiCallFailure))
                }
            }
            return Disposables.create()
        }
    }
    
    public class func executeDownloadToFile(url: String) -> Single<String> {
        return Single<String>.create(subscribe: { (observer) -> Disposable in
            if url.doesFileExistInDocumentsDir() {
                observer(SingleEvent.success(url.getDocumentsDirectoryFilePathFromRemotePath()!))
            } else {
                let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
                
                sessionManager.download(url, to: destination).response { response in
                    if let downloadError = response.error {
                        observer(SingleEvent.error(downloadError))
                    } else {
                        let filePath: String = response.destinationURL!.path
                        
                        observer(SingleEvent.success(filePath))
                    }
                }
            }
            return Disposables.create()
        })
    }
    
    public class func executeApiCall(call: URLRequestConvertible, parseError: @escaping (Any?) -> String) -> Single<Any?> {
        return Single<Any?>.create { observer in
            clearCacheIfDev()
            
            sessionManager.request(call)
                .responseJSON { (response: DataResponse<Any>) in
                    let responseCode: Int? = response.response?.statusCode
                    switch response.result {
                    case .success:
                        _ = determineErrorResponse(response: response, responseStatusCode: responseCode!, parseError: parseError)
                            .subscribeSingle({ (responseValue) in
                                observer(SingleEvent.success(responseValue))
                            }, onError: { (error) in
                                observer(SingleEvent.error(error))
                            })
                    case .failure(let error):
                        responseFailureEncountered(error, observer: observer, responseCode: responseCode, response: response)
                    }
            }
            return Disposables.create()
        }
    }
    
    private class func responseFailureEncountered(_ error: Error, observer: (SingleEvent<Any?>) -> (), responseCode: Int?, response: DataResponse<Any>) {
        if let urlError = error as? URLError {
            var networkError: Error? = nil
            
            if urlError.code == URLError.Code.notConnectedToInternet {
                networkError = MacAPIError.noInternetConnection
            } else if urlError.code == URLError.Code.timedOut || urlError.code == URLError.Code.networkConnectionLost {
                networkError = MacAPIError.connectionTimeout
            } else {
//                MacConfigInstance?.macErrorNotifier.errorEncountered(error: error)
                networkError = MacAPIError.backendNetworkError
            }
            
            if let macConfigError = MacConfigInstance?.macProcessApiResponse.error(error: networkError, statusCode: responseCode, rawResponse: response, responseBody: response.value, headers: response.response?.allHeaderFields) {
                observer(SingleEvent.error(macConfigError))
            } else {
                observer(SingleEvent.error(networkError!))
            }
        } else {
            MacConfigInstance?.macErrorNotifier.errorEncountered(error: error)
            
            if let macConfigError = MacConfigInstance?.macProcessApiResponse.error(error: error, statusCode: responseCode, rawResponse: response, responseBody: response.value, headers: response.response?.allHeaderFields) {
                observer(SingleEvent.error(macConfigError))
            } else {
                observer(SingleEvent.error(MacAPIError.apiCallFailure))
            }
        }
    }
    
    private class func determineErrorResponse(response: DataResponse<Any>, responseStatusCode: Int, parseError: @escaping (Any?) -> String) -> Single<Any?> {
        return Single<Any?>.create { observer in
            if responseStatusCode >= 200 && responseStatusCode < 300 {
                MacConfigInstance?.macProcessApiResponse.success(rawResponse: response, responseBody: response.value, headers: response.response!.allHeaderFields)
                observer(SingleEvent.success(response.value))
            } else {
                if let userProcessedError = MacConfigInstance?.macProcessApiResponse.error(error: nil, statusCode: responseStatusCode, rawResponse: response, responseBody: response.value, headers: response.response!.allHeaderFields) {
                    observer(SingleEvent.error(userProcessedError))
                } else {
                    switch responseStatusCode {
                    case _ where responseStatusCode >= 500:
                        let error = MacAPIError.api500ApiDown
                        observer(SingleEvent.error(error))
                        MacConfigInstance?.macErrorNotifier.errorEncountered(error: error)
                        break
                    case _ where responseStatusCode == 403:
                        let error = MacAPIError.api403UserNotEnoughPrivileges
                        observer(SingleEvent.error(error))
                        MacConfigInstance?.macErrorNotifier.errorEncountered(error: error)
                        break
                    case _ where responseStatusCode == 401:
                        observer(SingleEvent.error(MacAPIError.api401UserUnauthorized))
                        break
                    default:
                        observer(SingleEvent.error(MacAPIError.apiSome400error(errorMessage: parseError(response.value))))
                        break
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    private class func clearCacheIfDev() {
        #if DEBUG
            URLCache.shared.removeAllCachedResponses()
        #endif
    }
    
}
