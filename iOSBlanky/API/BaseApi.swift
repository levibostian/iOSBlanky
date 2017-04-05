//
//  BaseAPI.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import iOSBoilerplate
import Mac

class BaseApi {
    
    static let baseURL = AppConstants.apiEndpoint
    
    enum MimeType {
        case pngImage
        case jpegImage
        
        var description: String {
            switch self {
            case .pngImage: return "image/png"
            case .jpegImage: return "image/jpeg"
            }
        }
    }
    
    struct UploadMultipartFormData {
        var data: Data!
        var name: String!
    }
    
    struct UploadFileMultipartFormData {
        var data: Data!
        var multipartFormName: String!
        var fileName: String!
        var mimeType: MimeType!
    }
    
    class func clearCacheIfDev() {
        #if DEBUG
            URLCache.shared.removeAllCachedResponses()
        #endif
    }
    
    class func upload<ERROR_VO: ErrorResponseVo>(_ request: URLRequestConvertible, data: [UploadMultipartFormData]? = nil, files: [UploadFileMultipartFormData]? = nil, onComplete: (() -> Void)?, onError: ((String) -> Void)?, errorMessage: String, errorVo: ERROR_VO) {
        clearCacheIfDev()
        
        Alamofire.upload(multipartFormData: { (multiformData) in
            if let data = data {
                for formData in data {
                    multiformData.append(formData.data, withName: formData.name)
                }
            }
            if let files = files {
                for file in files {
                    multiformData.append(file.data, withName: file.multipartFormName, fileName: file.fileName, mimeType: file.mimeType.description)
                }
            }
        }, with: request) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    let responseCode = response.response!.statusCode
                    if !determineErrorResponse(response: response, responseStatusCode: responseCode, errorVo: errorVo, onError: onError) {
                        switch responseCode {
                        case _ where responseCode >= 200:
                            saveCredsFromResponseHeader(response.response?.allHeaderFields)
                                
                            onComplete?()
                            return
                        default:
                            onError?(errorMessage)
                        }
                    }
                })
            case .failure:
                onError?("Error preparing your upload. Please try again.")
            }
        }
    }
    
    class func uploadWithData<DATA: Mappable, ERROR_VO: ErrorResponseVo>(_ request: URLRequestConvertible, data: [UploadMultipartFormData]? = nil, files: [UploadFileMultipartFormData]? = nil, onComplete: ((DATA) -> Void)?, onError: ((String) -> Void)?, errorMessage: String, errorVo: ERROR_VO) {
        clearCacheIfDev()
        
        Alamofire.upload(multipartFormData: { (multiformData) in
            if let data = data {
                for formData in data {
                    multiformData.append(formData.data, withName: formData.name)
                }
            }
            if let files = files {
                for file in files {
                    multiformData.append(file.data, withName: file.multipartFormName, fileName: file.fileName, mimeType: file.mimeType.description)
                }
            }
        }, with: request) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    let responseCode = response.response!.statusCode
                    if !determineErrorResponse(response: response, responseStatusCode: responseCode, errorVo: errorVo, onError: onError) {
                        switch responseCode {
                        case _ where responseCode >= 200:
                            let responseData = Mapper<DATA>().map(JSONObject: response.result.value) // swiftlint:disable:this force_cast
                                
                            saveCredsFromResponseHeader(response.response?.allHeaderFields)
                                
                            onComplete?(responseData!)
                            return
                        default:
                            onError?(errorMessage)
                        }
                    }
                })
            case .failure:
                onError?("Error preparing your upload. Please try again.")
            }
        }
    }
    
    class func apiCall<ERROR_VO: ErrorResponseVo>(call: URLRequestConvertible, onComplete: (() -> Void)?, onError: ((String) -> Void)?, errorMessage: String, errorVo: ERROR_VO) {
        clearCacheIfDev()
        
        Alamofire.request(call)
            .responseJSON { (response: DataResponse<Any>) in
                let responseCode = response.response!.statusCode
                if !determineErrorResponse(response: response, responseStatusCode: responseCode, errorVo: errorVo, onError: onError) {
                    switch responseCode {
                    case _ where responseCode >= 200:
                        saveCredsFromResponseHeader(response.response?.allHeaderFields)
                            
                        onComplete?()
                        return
                    default:
                        onError?(errorMessage)
                    }
                }
        }
    }
    
    class func apiCallWithData<DATA: Mappable, ERROR_VO: ErrorResponseVo>(call: URLRequestConvertible, onComplete: @escaping (DATA) -> Void, onError: @escaping (String) -> Void, errorMessage: String, errorVo: ERROR_VO) {
        clearCacheIfDev()
        
        Alamofire.request(call)
            .responseJSON { (response: DataResponse<Any>) in
                let responseCode = response.response!.statusCode
                if !determineErrorResponse(response: response, responseStatusCode: responseCode, errorVo: errorVo, onError: onError) {
                    switch responseCode {
                    case _ where responseCode >= 200:
                        let responseData = Mapper<DATA>().map(JSONObject: response.result.value) // swiftlint:disable:this force_cast
                            
                        saveCredsFromResponseHeader(response.response?.allHeaderFields)
                            
                        onComplete(responseData!)
                        return
                    default:
                        onError(errorMessage)
                    }
                }
        }
    }
    
    fileprivate class func saveCredsFromResponseHeader(_ headers: [AnyHashable: Any]?) {
        if let headers = headers {
//            let credsManager = UserCredsManager.Editor()
//            do {
//                try credsManager.setAuthToken(headers["access-token"] as? String)
//                    .commit()
//            } catch {
//                LogUtil.logError(error)
//            }
        }
    }
    
    class func apiCallArray<DATA: Mappable, ERROR_VO: ErrorResponseVo>(call: URLRequestConvertible, onComplete: @escaping ([DATA]) -> Void, onError: @escaping (String) -> Void, errorMessage: String, errorVo: ERROR_VO) {
        Alamofire.request(call)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let responseCode = response.response!.statusCode
                    if !determineErrorResponse(response: response, responseStatusCode: responseCode, errorVo: errorVo, onError: onError) {
                        switch responseCode {
                        case _ where responseCode >= 200:
                            let responseData = Mapper<DATA>().mapArray(JSONArray: response.result.value as! [[String : Any]]) // swiftlint:disable:this force_cast
                            saveCredsFromResponseHeader(response.response?.allHeaderFields)
                                
                            onComplete(responseData!)
                            return
                        default:
                            onError(errorMessage)
                        }
                    }
                case .failure:
                    onError(errorMessage)
                }
        }
    }
    
    class func determineErrorResponse<ERROR_VO: ErrorResponseVo>(response: DataResponse<Any>, responseStatusCode: Int, errorVo: ERROR_VO, onError: ((String) -> Void)?) -> Bool {
        
        switch responseStatusCode {
        case _ where responseStatusCode >= 500:
            onError?("The system is currently down. Come back later and try again.")
            return true
        case _ where responseStatusCode == 403:
            onError?("You do not have enough privileges to continue.")
            return true
        case _ where responseStatusCode == 401:
            let responseData = Mapper<ERROR_VO>().map(JSONObject: response.result.value) // swiftlint:disable:this force_cast
            
            NotificationCenterUtil.postUserUnauthorized(true, errorMessage: responseData?.getErrorMessageToDisplayToUser() ?? "")
            return true
        case _ where responseStatusCode >= 400:
            let responseData = Mapper<ERROR_VO>().map(JSONObject: response.result.value) // swiftlint:disable:this force_cast
            
            if let responseError = responseData?.getErrorMessageToDisplayToUser() {
                onError?(responseError)
            }
            return true
        default:
            return false
        }
    }
    
}
