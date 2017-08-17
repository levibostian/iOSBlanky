//
//  MacAPIError.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation

public enum MacAPIError: Error, LocalizedError {
    case parseErrorFromAPIException
    
    case apiCallFailure
    case api500ApiDown
    case api403UserNotEnoughPrivileges
    case api401UserUnauthorized
    case apiSome400error(errorMessage: String)
    
    case noInternetConnection
    case connectionTimeout
    case backendNetworkError // happens when user encountered network error that is more then likely not the user's problem. You should log this and take care of the issue. 
    
    public var errorDescription: String? {
        switch self {
        case .apiCallFailure:
            return NSLocalizedString("There seems to be an error. Sorry about that. Try again.", comment: "")
        case .api500ApiDown:
            return NSLocalizedString("The system is currently down. Come back later and try again.", comment: "")
        case .api403UserNotEnoughPrivileges:
            return NSLocalizedString("You do not have enough privileges to continue.", comment: "This should not happen.")
        case .api401UserUnauthorized:
            return NSLocalizedString("Unauthorized", comment: "")
        case .apiSome400error(let errorMessage):
            return NSLocalizedString(errorMessage, comment: "")
            
        case .parseErrorFromAPIException:
            return NSLocalizedString("Unknown error. Sorry, try again.", comment: "")
            
        case .noInternetConnection:
            return NSLocalizedString("Not connected to the Internet.", comment: "")
        case .connectionTimeout:
            return NSLocalizedString("Lost connection to the Internet. Please, try again.", comment: "")
        case .backendNetworkError:
            return NSLocalizedString("We encountered an issue with the app. Please, try again later.", comment: "")
        }
    }
}
