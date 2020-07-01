// swiftlint:disable line_length
// swiftlint:disable variable_name
// swiftlint:disable large_tuple

import Foundation
import RxSwift
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

class ActivityLoggerMock: ActivityLogger {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - setUserId

    var setUserIdIdCallsCount = 0
    var setUserIdIdCalled: Bool {
        setUserIdIdCallsCount > 0
    }

    var setUserIdIdReceivedId: String?
    var setUserIdIdReceivedInvocations: [String?] = []
    var setUserIdIdClosure: ((String?) -> Void)?

    func setUserId(id: String?) {
        mockCalled = true
        setUserIdIdCallsCount += 1
        setUserIdIdReceivedId = id
        setUserIdIdReceivedInvocations.append(id)
        setUserIdIdClosure?(id)
    }

    // MARK: - appEventOccurred

    var appEventOccurredExtrasAverageFromCallsCount = 0
    var appEventOccurredExtrasAverageFromCalled: Bool {
        appEventOccurredExtrasAverageFromCallsCount > 0
    }

    var appEventOccurredExtrasAverageFromReceivedArguments: (event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, file: String)?
    var appEventOccurredExtrasAverageFromReceivedInvocations: [(event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, file: String)] = []
    var appEventOccurredExtrasAverageFromClosure: ((ActivityEvent, [ActivityEventParamKey: Any]?, Double?, String) -> Void)?

    func appEventOccurred(_ event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, from file: String) {
        mockCalled = true
        appEventOccurredExtrasAverageFromCallsCount += 1
        appEventOccurredExtrasAverageFromReceivedArguments = (event: event, extras: extras, average: average, file: file)
        appEventOccurredExtrasAverageFromReceivedInvocations.append((event: event, extras: extras, average: average, file: file))
        appEventOccurredExtrasAverageFromClosure?(event, extras, average, file)
    }

    // MARK: - setUserProperty

    var setUserPropertyValueCallsCount = 0
    var setUserPropertyValueCalled: Bool {
        setUserPropertyValueCallsCount > 0
    }

    var setUserPropertyValueReceivedArguments: (key: UserPropertyKey, value: String)?
    var setUserPropertyValueReceivedInvocations: [(key: UserPropertyKey, value: String)] = []
    var setUserPropertyValueClosure: ((UserPropertyKey, String) -> Void)?

    func setUserProperty(_ key: UserPropertyKey, value: String) {
        mockCalled = true
        setUserPropertyValueCallsCount += 1
        setUserPropertyValueReceivedArguments = (key: key, value: value)
        setUserPropertyValueReceivedInvocations.append((key: key, value: value))
        setUserPropertyValueClosure?(key, value)
    }

    // MARK: - breadcrumb

    var breadcrumbExtrasFromCallsCount = 0
    var breadcrumbExtrasFromCalled: Bool {
        breadcrumbExtrasFromCallsCount > 0
    }

    var breadcrumbExtrasFromReceivedArguments: (event: String, extras: [String: Any]?, file: String)?
    var breadcrumbExtrasFromReceivedInvocations: [(event: String, extras: [String: Any]?, file: String)] = []
    var breadcrumbExtrasFromClosure: ((String, [String: Any]?, String) -> Void)?

    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String) {
        mockCalled = true
        breadcrumbExtrasFromCallsCount += 1
        breadcrumbExtrasFromReceivedArguments = (event: event, extras: extras, file: file)
        breadcrumbExtrasFromReceivedInvocations.append((event: event, extras: extras, file: file))
        breadcrumbExtrasFromClosure?(event, extras, file)
    }

    // MARK: - httpRequestEvent

    var httpRequestEventMethodUrlReqBodyCallsCount = 0
    var httpRequestEventMethodUrlReqBodyCalled: Bool {
        httpRequestEventMethodUrlReqBodyCallsCount > 0
    }

    var httpRequestEventMethodUrlReqBodyReceivedArguments: (method: String, url: String, reqBody: String?)?
    var httpRequestEventMethodUrlReqBodyReceivedInvocations: [(method: String, url: String, reqBody: String?)] = []
    var httpRequestEventMethodUrlReqBodyClosure: ((String, String, String?) -> Void)?

    func httpRequestEvent(method: String, url: String, reqBody: String?) {
        mockCalled = true
        httpRequestEventMethodUrlReqBodyCallsCount += 1
        httpRequestEventMethodUrlReqBodyReceivedArguments = (method: method, url: url, reqBody: reqBody)
        httpRequestEventMethodUrlReqBodyReceivedInvocations.append((method: method, url: url, reqBody: reqBody))
        httpRequestEventMethodUrlReqBodyClosure?(method, url, reqBody)
    }

    // MARK: - httpSuccessEvent

    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount = 0
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCalled: Bool {
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount > 0
    }

    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments: (method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)?
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations: [(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)] = []
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyClosure: ((String, String, Int, String?, String?, String?) -> Void)?

    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        mockCalled = true
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount += 1
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments = (method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations.append((method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody))
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyClosure?(method, url, code, reqHeaders, resHeaders, resBody)
    }

    // MARK: - httpFailEvent

    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount = 0
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCalled: Bool {
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount > 0
    }

    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments: (method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)?
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations: [(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)] = []
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyClosure: ((String, String, Int, String?, String?, String?) -> Void)?

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        mockCalled = true
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount += 1
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments = (method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations.append((method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody))
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyClosure?(method, url, code, reqHeaders, resHeaders, resBody)
    }

    // MARK: - errorOccurred

    var errorOccurredCallsCount = 0
    var errorOccurredCalled: Bool {
        errorOccurredCallsCount > 0
    }

    var errorOccurredReceivedError: Error?
    var errorOccurredReceivedInvocations: [Error] = []
    var errorOccurredClosure: ((Error) -> Void)?

    func errorOccurred(_ error: Error) {
        mockCalled = true
        errorOccurredCallsCount += 1
        errorOccurredReceivedError = error
        errorOccurredReceivedInvocations.append(error)
        errorOccurredClosure?(error)
    }
}

class DebugActivityLoggerMock: DebugActivityLogger {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - identifyUser

    var identifyUserIdCallsCount = 0
    var identifyUserIdCalled: Bool {
        identifyUserIdCallsCount > 0
    }

    var identifyUserIdReceivedId: String?
    var identifyUserIdReceivedInvocations: [String?] = []
    var identifyUserIdClosure: ((String?) -> Void)?

    func identifyUser(id: String?) {
        mockCalled = true
        identifyUserIdCallsCount += 1
        identifyUserIdReceivedId = id
        identifyUserIdReceivedInvocations.append(id)
        identifyUserIdClosure?(id)
    }

    // MARK: - logAppEvent

    var logAppEventExtrasCallsCount = 0
    var logAppEventExtrasCalled: Bool {
        logAppEventExtrasCallsCount > 0
    }

    var logAppEventExtrasReceivedArguments: (message: String, extras: [String: Any]?)?
    var logAppEventExtrasReceivedInvocations: [(message: String, extras: [String: Any]?)] = []
    var logAppEventExtrasClosure: ((String, [String: Any]?) -> Void)?

    func logAppEvent(_ message: String, extras: [String: Any]?) {
        mockCalled = true
        logAppEventExtrasCallsCount += 1
        logAppEventExtrasReceivedArguments = (message: message, extras: extras)
        logAppEventExtrasReceivedInvocations.append((message: message, extras: extras))
        logAppEventExtrasClosure?(message, extras)
    }

    // MARK: - logDebug

    var logDebugExtrasCallsCount = 0
    var logDebugExtrasCalled: Bool {
        logDebugExtrasCallsCount > 0
    }

    var logDebugExtrasReceivedArguments: (message: String, extras: [String: Any]?)?
    var logDebugExtrasReceivedInvocations: [(message: String, extras: [String: Any]?)] = []
    var logDebugExtrasClosure: ((String, [String: Any]?) -> Void)?

    func logDebug(_ message: String, extras: [String: Any]?) {
        mockCalled = true
        logDebugExtrasCallsCount += 1
        logDebugExtrasReceivedArguments = (message: message, extras: extras)
        logDebugExtrasReceivedInvocations.append((message: message, extras: extras))
        logDebugExtrasClosure?(message, extras)
    }

    // MARK: - logError

    var logErrorCallsCount = 0
    var logErrorCalled: Bool {
        logErrorCallsCount > 0
    }

    var logErrorReceivedError: Error?
    var logErrorReceivedInvocations: [Error] = []
    var logErrorClosure: ((Error) -> Void)?

    func logError(_ error: Error) {
        mockCalled = true
        logErrorCallsCount += 1
        logErrorReceivedError = error
        logErrorReceivedInvocations.append(error)
        logErrorClosure?(error)
    }

    // MARK: - setUserId

    var setUserIdIdCallsCount = 0
    var setUserIdIdCalled: Bool {
        setUserIdIdCallsCount > 0
    }

    var setUserIdIdReceivedId: String?
    var setUserIdIdReceivedInvocations: [String?] = []
    var setUserIdIdClosure: ((String?) -> Void)?

    func setUserId(id: String?) {
        mockCalled = true
        setUserIdIdCallsCount += 1
        setUserIdIdReceivedId = id
        setUserIdIdReceivedInvocations.append(id)
        setUserIdIdClosure?(id)
    }

    // MARK: - appEventOccurred

    var appEventOccurredExtrasAverageFromCallsCount = 0
    var appEventOccurredExtrasAverageFromCalled: Bool {
        appEventOccurredExtrasAverageFromCallsCount > 0
    }

    var appEventOccurredExtrasAverageFromReceivedArguments: (event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, file: String)?
    var appEventOccurredExtrasAverageFromReceivedInvocations: [(event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, file: String)] = []
    var appEventOccurredExtrasAverageFromClosure: ((ActivityEvent, [ActivityEventParamKey: Any]?, Double?, String) -> Void)?

    func appEventOccurred(_ event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, from file: String) {
        mockCalled = true
        appEventOccurredExtrasAverageFromCallsCount += 1
        appEventOccurredExtrasAverageFromReceivedArguments = (event: event, extras: extras, average: average, file: file)
        appEventOccurredExtrasAverageFromReceivedInvocations.append((event: event, extras: extras, average: average, file: file))
        appEventOccurredExtrasAverageFromClosure?(event, extras, average, file)
    }

    // MARK: - setUserProperty

    var setUserPropertyValueCallsCount = 0
    var setUserPropertyValueCalled: Bool {
        setUserPropertyValueCallsCount > 0
    }

    var setUserPropertyValueReceivedArguments: (key: UserPropertyKey, value: String)?
    var setUserPropertyValueReceivedInvocations: [(key: UserPropertyKey, value: String)] = []
    var setUserPropertyValueClosure: ((UserPropertyKey, String) -> Void)?

    func setUserProperty(_ key: UserPropertyKey, value: String) {
        mockCalled = true
        setUserPropertyValueCallsCount += 1
        setUserPropertyValueReceivedArguments = (key: key, value: value)
        setUserPropertyValueReceivedInvocations.append((key: key, value: value))
        setUserPropertyValueClosure?(key, value)
    }

    // MARK: - breadcrumb

    var breadcrumbExtrasFromCallsCount = 0
    var breadcrumbExtrasFromCalled: Bool {
        breadcrumbExtrasFromCallsCount > 0
    }

    var breadcrumbExtrasFromReceivedArguments: (event: String, extras: [String: Any]?, file: String)?
    var breadcrumbExtrasFromReceivedInvocations: [(event: String, extras: [String: Any]?, file: String)] = []
    var breadcrumbExtrasFromClosure: ((String, [String: Any]?, String) -> Void)?

    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String) {
        mockCalled = true
        breadcrumbExtrasFromCallsCount += 1
        breadcrumbExtrasFromReceivedArguments = (event: event, extras: extras, file: file)
        breadcrumbExtrasFromReceivedInvocations.append((event: event, extras: extras, file: file))
        breadcrumbExtrasFromClosure?(event, extras, file)
    }

    // MARK: - httpRequestEvent

    var httpRequestEventMethodUrlReqBodyCallsCount = 0
    var httpRequestEventMethodUrlReqBodyCalled: Bool {
        httpRequestEventMethodUrlReqBodyCallsCount > 0
    }

    var httpRequestEventMethodUrlReqBodyReceivedArguments: (method: String, url: String, reqBody: String?)?
    var httpRequestEventMethodUrlReqBodyReceivedInvocations: [(method: String, url: String, reqBody: String?)] = []
    var httpRequestEventMethodUrlReqBodyClosure: ((String, String, String?) -> Void)?

    func httpRequestEvent(method: String, url: String, reqBody: String?) {
        mockCalled = true
        httpRequestEventMethodUrlReqBodyCallsCount += 1
        httpRequestEventMethodUrlReqBodyReceivedArguments = (method: method, url: url, reqBody: reqBody)
        httpRequestEventMethodUrlReqBodyReceivedInvocations.append((method: method, url: url, reqBody: reqBody))
        httpRequestEventMethodUrlReqBodyClosure?(method, url, reqBody)
    }

    // MARK: - httpSuccessEvent

    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount = 0
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCalled: Bool {
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount > 0
    }

    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments: (method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)?
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations: [(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)] = []
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyClosure: ((String, String, Int, String?, String?, String?) -> Void)?

    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        mockCalled = true
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount += 1
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments = (method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations.append((method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody))
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyClosure?(method, url, code, reqHeaders, resHeaders, resBody)
    }

    // MARK: - httpFailEvent

    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount = 0
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCalled: Bool {
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount > 0
    }

    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments: (method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)?
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations: [(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)] = []
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyClosure: ((String, String, Int, String?, String?, String?) -> Void)?

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        mockCalled = true
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount += 1
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments = (method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations.append((method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody))
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyClosure?(method, url, code, reqHeaders, resHeaders, resBody)
    }

    // MARK: - errorOccurred

    var errorOccurredCallsCount = 0
    var errorOccurredCalled: Bool {
        errorOccurredCallsCount > 0
    }

    var errorOccurredReceivedError: Error?
    var errorOccurredReceivedInvocations: [Error] = []
    var errorOccurredClosure: ((Error) -> Void)?

    func errorOccurred(_ error: Error) {
        mockCalled = true
        errorOccurredCallsCount += 1
        errorOccurredReceivedError = error
        errorOccurredReceivedInvocations.append(error)
        errorOccurredClosure?(error)
    }
}

class EventBusMock: EventBus {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - post

    var postExtrasCallsCount = 0
    var postExtrasCalled: Bool {
        postExtrasCallsCount > 0
    }

    var postExtrasReceivedArguments: (event: EventBusEvent, extras: EventBusExtras?)?
    var postExtrasReceivedInvocations: [(event: EventBusEvent, extras: EventBusExtras?)] = []
    var postExtrasClosure: ((EventBusEvent, EventBusExtras?) -> Void)?

    func post(_ event: EventBusEvent, extras: EventBusExtras?) {
        mockCalled = true
        postExtrasCallsCount += 1
        postExtrasReceivedArguments = (event: event, extras: extras)
        postExtrasReceivedInvocations.append((event: event, extras: extras))
        postExtrasClosure?(event, extras)
    }

    // MARK: - register

    var registerEventCallsCount = 0
    var registerEventCalled: Bool {
        registerEventCallsCount > 0
    }

    var registerEventReceivedArguments: (listener: EventBusEventListener, event: EventBusEvent)?
    var registerEventReceivedInvocations: [(listener: EventBusEventListener, event: EventBusEvent)] = []
    var registerEventClosure: ((EventBusEventListener, EventBusEvent) -> Void)?

    func register(_ listener: EventBusEventListener, event: EventBusEvent) {
        mockCalled = true
        registerEventCallsCount += 1
        registerEventReceivedArguments = (listener: listener, event: event)
        registerEventReceivedInvocations.append((listener: listener, event: event))
        registerEventClosure?(listener, event)
    }

    // MARK: - unregister

    var unregisterEventCallsCount = 0
    var unregisterEventCalled: Bool {
        unregisterEventCallsCount > 0
    }

    var unregisterEventReceivedArguments: (listener: EventBusEventListener, event: EventBusEvent)?
    var unregisterEventReceivedInvocations: [(listener: EventBusEventListener, event: EventBusEvent)] = []
    var unregisterEventClosure: ((EventBusEventListener, EventBusEvent) -> Void)?

    func unregister(_ listener: EventBusEventListener, event: EventBusEvent) {
        mockCalled = true
        unregisterEventCallsCount += 1
        unregisterEventReceivedArguments = (listener: listener, event: event)
        unregisterEventReceivedInvocations.append((listener: listener, event: event))
        unregisterEventClosure?(listener, event)
    }

    // MARK: - unregisterAll

    var unregisterAllCallsCount = 0
    var unregisterAllCalled: Bool {
        unregisterAllCallsCount > 0
    }

    var unregisterAllReceivedListener: EventBusEventListener?
    var unregisterAllReceivedInvocations: [EventBusEventListener] = []
    var unregisterAllClosure: ((EventBusEventListener) -> Void)?

    func unregisterAll(_ listener: EventBusEventListener) {
        mockCalled = true
        unregisterAllCallsCount += 1
        unregisterAllReceivedListener = listener
        unregisterAllReceivedInvocations.append(listener)
        unregisterAllClosure?(listener)
    }
}

class EventBusEventListenerMock: EventBusEventListener {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - eventBusEvent

    var eventBusEventExtrasCallsCount = 0
    var eventBusEventExtrasCalled: Bool {
        eventBusEventExtrasCallsCount > 0
    }

    var eventBusEventExtrasReceivedArguments: (event: EventBusEvent, extras: EventBusExtras?)?
    var eventBusEventExtrasReceivedInvocations: [(event: EventBusEvent, extras: EventBusExtras?)] = []
    var eventBusEventExtrasClosure: ((EventBusEvent, EventBusExtras?) -> Void)?

    func eventBusEvent(_ event: EventBusEvent, extras: EventBusExtras?) {
        mockCalled = true
        eventBusEventExtrasCallsCount += 1
        eventBusEventExtrasReceivedArguments = (event: event, extras: extras)
        eventBusEventExtrasReceivedInvocations.append((event: event, extras: extras))
        eventBusEventExtrasClosure?(event, extras)
    }
}

class FileStorageMock: FileStorage {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - write

    var writeTextFileNameInSearchPathAppendedDirectoryThrowableError: Error?
    var writeTextFileNameInSearchPathAppendedDirectoryCallsCount = 0
    var writeTextFileNameInSearchPathAppendedDirectoryCalled: Bool {
        writeTextFileNameInSearchPathAppendedDirectoryCallsCount > 0
    }

    var writeTextFileNameInSearchPathAppendedDirectoryReceivedArguments: (text: String, fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)?
    var writeTextFileNameInSearchPathAppendedDirectoryReceivedInvocations: [(text: String, fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)] = []
    var writeTextFileNameInSearchPathAppendedDirectoryClosure: ((String, String, FileManager.SearchPathDirectory, String?) throws -> Void)?

    func write(text: String, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws {
        if let error = writeTextFileNameInSearchPathAppendedDirectoryThrowableError {
            throw error
        }
        mockCalled = true
        writeTextFileNameInSearchPathAppendedDirectoryCallsCount += 1
        writeTextFileNameInSearchPathAppendedDirectoryReceivedArguments = (text: text, fileName: fileName, location: location, appendedDirectory: appendedDirectory)
        writeTextFileNameInSearchPathAppendedDirectoryReceivedInvocations.append((text: text, fileName: fileName, location: location, appendedDirectory: appendedDirectory))
        try writeTextFileNameInSearchPathAppendedDirectoryClosure?(text, fileName, location, appendedDirectory)
    }

    // MARK: - readString

    var readStringFileNameInSearchPathAppendedDirectoryCallsCount = 0
    var readStringFileNameInSearchPathAppendedDirectoryCalled: Bool {
        readStringFileNameInSearchPathAppendedDirectoryCallsCount > 0
    }

    var readStringFileNameInSearchPathAppendedDirectoryReceivedArguments: (fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)?
    var readStringFileNameInSearchPathAppendedDirectoryReceivedInvocations: [(fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)] = []
    var readStringFileNameInSearchPathAppendedDirectoryReturnValue: String?
    var readStringFileNameInSearchPathAppendedDirectoryClosure: ((String, FileManager.SearchPathDirectory, String?) -> String?)?

    func readString(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> String? {
        mockCalled = true
        readStringFileNameInSearchPathAppendedDirectoryCallsCount += 1
        readStringFileNameInSearchPathAppendedDirectoryReceivedArguments = (fileName: fileName, location: location, appendedDirectory: appendedDirectory)
        readStringFileNameInSearchPathAppendedDirectoryReceivedInvocations.append((fileName: fileName, location: location, appendedDirectory: appendedDirectory))
        return readStringFileNameInSearchPathAppendedDirectoryClosure.map { $0(fileName, location, appendedDirectory) } ?? readStringFileNameInSearchPathAppendedDirectoryReturnValue
    }

    // MARK: - readAsset

    var readAssetAssetCallsCount = 0
    var readAssetAssetCalled: Bool {
        readAssetAssetCallsCount > 0
    }

    var readAssetAssetReceivedAsset: FileAsset?
    var readAssetAssetReceivedInvocations: [FileAsset] = []
    var readAssetAssetReturnValue: Data?
    var readAssetAssetClosure: ((FileAsset) -> Data?)?

    func readAsset(asset: FileAsset) -> Data? {
        mockCalled = true
        readAssetAssetCallsCount += 1
        readAssetAssetReceivedAsset = asset
        readAssetAssetReceivedInvocations.append(asset)
        return readAssetAssetClosure.map { $0(asset) } ?? readAssetAssetReturnValue
    }

    // MARK: - write

    var writeDataFileNameInSearchPathAppendedDirectoryThrowableError: Error?
    var writeDataFileNameInSearchPathAppendedDirectoryCallsCount = 0
    var writeDataFileNameInSearchPathAppendedDirectoryCalled: Bool {
        writeDataFileNameInSearchPathAppendedDirectoryCallsCount > 0
    }

    var writeDataFileNameInSearchPathAppendedDirectoryReceivedArguments: (data: Data, fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)?
    var writeDataFileNameInSearchPathAppendedDirectoryReceivedInvocations: [(data: Data, fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)] = []
    var writeDataFileNameInSearchPathAppendedDirectoryClosure: ((Data, String, FileManager.SearchPathDirectory, String?) throws -> Void)?

    func write(data: Data, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws {
        if let error = writeDataFileNameInSearchPathAppendedDirectoryThrowableError {
            throw error
        }
        mockCalled = true
        writeDataFileNameInSearchPathAppendedDirectoryCallsCount += 1
        writeDataFileNameInSearchPathAppendedDirectoryReceivedArguments = (data: data, fileName: fileName, location: location, appendedDirectory: appendedDirectory)
        writeDataFileNameInSearchPathAppendedDirectoryReceivedInvocations.append((data: data, fileName: fileName, location: location, appendedDirectory: appendedDirectory))
        try writeDataFileNameInSearchPathAppendedDirectoryClosure?(data, fileName, location, appendedDirectory)
    }

    // MARK: - readData

    var readDataFileNameInSearchPathAppendedDirectoryCallsCount = 0
    var readDataFileNameInSearchPathAppendedDirectoryCalled: Bool {
        readDataFileNameInSearchPathAppendedDirectoryCallsCount > 0
    }

    var readDataFileNameInSearchPathAppendedDirectoryReceivedArguments: (fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)?
    var readDataFileNameInSearchPathAppendedDirectoryReceivedInvocations: [(fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)] = []
    var readDataFileNameInSearchPathAppendedDirectoryReturnValue: Data?
    var readDataFileNameInSearchPathAppendedDirectoryClosure: ((String, FileManager.SearchPathDirectory, String?) -> Data?)?

    func readData(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> Data? {
        mockCalled = true
        readDataFileNameInSearchPathAppendedDirectoryCallsCount += 1
        readDataFileNameInSearchPathAppendedDirectoryReceivedArguments = (fileName: fileName, location: location, appendedDirectory: appendedDirectory)
        readDataFileNameInSearchPathAppendedDirectoryReceivedInvocations.append((fileName: fileName, location: location, appendedDirectory: appendedDirectory))
        return readDataFileNameInSearchPathAppendedDirectoryClosure.map { $0(fileName, location, appendedDirectory) } ?? readDataFileNameInSearchPathAppendedDirectoryReturnValue
    }

    // MARK: - getFileUrl

    var getFileUrlFileNameInSearchPathAppendedDirectoryCallsCount = 0
    var getFileUrlFileNameInSearchPathAppendedDirectoryCalled: Bool {
        getFileUrlFileNameInSearchPathAppendedDirectoryCallsCount > 0
    }

    var getFileUrlFileNameInSearchPathAppendedDirectoryReceivedArguments: (fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)?
    var getFileUrlFileNameInSearchPathAppendedDirectoryReceivedInvocations: [(fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)] = []
    var getFileUrlFileNameInSearchPathAppendedDirectoryReturnValue: URL!
    var getFileUrlFileNameInSearchPathAppendedDirectoryClosure: ((String, FileManager.SearchPathDirectory, String?) -> URL)?

    func getFileUrl(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> URL {
        mockCalled = true
        getFileUrlFileNameInSearchPathAppendedDirectoryCallsCount += 1
        getFileUrlFileNameInSearchPathAppendedDirectoryReceivedArguments = (fileName: fileName, location: location, appendedDirectory: appendedDirectory)
        getFileUrlFileNameInSearchPathAppendedDirectoryReceivedInvocations.append((fileName: fileName, location: location, appendedDirectory: appendedDirectory))
        return getFileUrlFileNameInSearchPathAppendedDirectoryClosure.map { $0(fileName, location, appendedDirectory) } ?? getFileUrlFileNameInSearchPathAppendedDirectoryReturnValue
    }

    // MARK: - getTempFileUrl

    var getTempFileUrlCallsCount = 0
    var getTempFileUrlCalled: Bool {
        getTempFileUrlCallsCount > 0
    }

    var getTempFileUrlReturnValue: URL!
    var getTempFileUrlClosure: (() -> URL)?

    func getTempFileUrl() -> URL {
        mockCalled = true
        getTempFileUrlCallsCount += 1
        return getTempFileUrlClosure.map { $0() } ?? getTempFileUrlReturnValue
    }

    // MARK: - copy

    var copyFromToThrowableError: Error?
    var copyFromToCallsCount = 0
    var copyFromToCalled: Bool {
        copyFromToCallsCount > 0
    }

    var copyFromToReceivedArguments: (from: URL, to: URL)?
    var copyFromToReceivedInvocations: [(from: URL, to: URL)] = []
    var copyFromToClosure: ((URL, URL) throws -> Void)?

    func copy(from: URL, to: URL) throws {
        if let error = copyFromToThrowableError {
            throw error
        }
        mockCalled = true
        copyFromToCallsCount += 1
        copyFromToReceivedArguments = (from: from, to: to)
        copyFromToReceivedInvocations.append((from: from, to: to))
        try copyFromToClosure?(from, to)
    }

    // MARK: - delete

    var deleteThrowableError: Error?
    var deleteCallsCount = 0
    var deleteCalled: Bool {
        deleteCallsCount > 0
    }

    var deleteReceivedUrl: URL?
    var deleteReceivedInvocations: [URL] = []
    var deleteClosure: ((URL) throws -> Void)?

    func delete(_ url: URL) throws {
        if let error = deleteThrowableError {
            throw error
        }
        mockCalled = true
        deleteCallsCount += 1
        deleteReceivedUrl = url
        deleteReceivedInvocations.append(url)
        try deleteClosure?(url)
    }

    // MARK: - doesFileExist

    var doesFileExistAtCallsCount = 0
    var doesFileExistAtCalled: Bool {
        doesFileExistAtCallsCount > 0
    }

    var doesFileExistAtReceivedAt: URL?
    var doesFileExistAtReceivedInvocations: [URL] = []
    var doesFileExistAtReturnValue: Bool!
    var doesFileExistAtClosure: ((URL) -> Bool)?

    func doesFileExist(at: URL) -> Bool {
        mockCalled = true
        doesFileExistAtCallsCount += 1
        doesFileExistAtReceivedAt = at
        doesFileExistAtReceivedInvocations.append(at)
        return doesFileExistAtClosure.map { $0(at) } ?? doesFileExistAtReturnValue
    }

    // MARK: - deleteAll

    var deleteAllInSearchPathThrowableError: Error?
    var deleteAllInSearchPathCallsCount = 0
    var deleteAllInSearchPathCalled: Bool {
        deleteAllInSearchPathCallsCount > 0
    }

    var deleteAllInSearchPathReceivedInSearchPath: FileManager.SearchPathDirectory?
    var deleteAllInSearchPathReceivedInvocations: [FileManager.SearchPathDirectory] = []
    var deleteAllInSearchPathClosure: ((FileManager.SearchPathDirectory) throws -> Void)?

    func deleteAll(inSearchPath: FileManager.SearchPathDirectory) throws {
        if let error = deleteAllInSearchPathThrowableError {
            throw error
        }
        mockCalled = true
        deleteAllInSearchPathCallsCount += 1
        deleteAllInSearchPathReceivedInSearchPath = inSearchPath
        deleteAllInSearchPathReceivedInvocations.append(inSearchPath)
        try deleteAllInSearchPathClosure?(inSearchPath)
    }

    // MARK: - observeFile

    var observeFileFileNameInSearchPathAppendedDirectoryCallsCount = 0
    var observeFileFileNameInSearchPathAppendedDirectoryCalled: Bool {
        observeFileFileNameInSearchPathAppendedDirectoryCallsCount > 0
    }

    var observeFileFileNameInSearchPathAppendedDirectoryReceivedArguments: (fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)?
    var observeFileFileNameInSearchPathAppendedDirectoryReceivedInvocations: [(fileName: String, location: FileManager.SearchPathDirectory, appendedDirectory: String?)] = []
    var observeFileFileNameInSearchPathAppendedDirectoryReturnValue: Observable<Optnal<Data>>!
    var observeFileFileNameInSearchPathAppendedDirectoryClosure: ((String, FileManager.SearchPathDirectory, String?) -> Observable<Optnal<Data>>)?

    func observeFile(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> Observable<Optnal<Data>> {
        mockCalled = true
        observeFileFileNameInSearchPathAppendedDirectoryCallsCount += 1
        observeFileFileNameInSearchPathAppendedDirectoryReceivedArguments = (fileName: fileName, location: location, appendedDirectory: appendedDirectory)
        observeFileFileNameInSearchPathAppendedDirectoryReceivedInvocations.append((fileName: fileName, location: location, appendedDirectory: appendedDirectory))
        return observeFileFileNameInSearchPathAppendedDirectoryClosure.map { $0(fileName, location, appendedDirectory) } ?? observeFileFileNameInSearchPathAppendedDirectoryReturnValue
    }
}

class GitHubAPIMock: GitHubAPI {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - exchangeToken

    var exchangeTokenTokenCallsCount = 0
    var exchangeTokenTokenCalled: Bool {
        exchangeTokenTokenCallsCount > 0
    }

    var exchangeTokenTokenReceivedToken: String?
    var exchangeTokenTokenReceivedInvocations: [String] = []
    var exchangeTokenTokenReturnValue: Single<Result<TokenExchangeResponseVo, HttpRequestError>>!
    var exchangeTokenTokenClosure: ((String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>>)?

    func exchangeToken(token: String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>> {
        mockCalled = true
        exchangeTokenTokenCallsCount += 1
        exchangeTokenTokenReceivedToken = token
        exchangeTokenTokenReceivedInvocations.append(token)
        return exchangeTokenTokenClosure.map { $0(token) } ?? exchangeTokenTokenReturnValue
    }

    // MARK: - getUserRepos

    var getUserReposUsernameCallsCount = 0
    var getUserReposUsernameCalled: Bool {
        getUserReposUsernameCallsCount > 0
    }

    var getUserReposUsernameReceivedUsername: GitHubUsername?
    var getUserReposUsernameReceivedInvocations: [GitHubUsername] = []
    var getUserReposUsernameReturnValue: Single<Result<[Repo], HttpRequestError>>!
    var getUserReposUsernameClosure: ((GitHubUsername) -> Single<Result<[Repo], HttpRequestError>>)?

    func getUserRepos(username: GitHubUsername) -> Single<Result<[Repo], HttpRequestError>> {
        mockCalled = true
        getUserReposUsernameCallsCount += 1
        getUserReposUsernameReceivedUsername = username
        getUserReposUsernameReceivedInvocations.append(username)
        return getUserReposUsernameClosure.map { $0(username) } ?? getUserReposUsernameReturnValue
    }
}

class KeyValueStorageMock: KeyValueStorage {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - integer

    var integerForKeyCallsCount = 0
    var integerForKeyCalled: Bool {
        integerForKeyCallsCount > 0
    }

    var integerForKeyReceivedKey: KeyValueStorageKey?
    var integerForKeyReceivedInvocations: [KeyValueStorageKey] = []
    var integerForKeyReturnValue: Int?
    var integerForKeyClosure: ((KeyValueStorageKey) -> Int?)?

    func integer(forKey key: KeyValueStorageKey) -> Int? {
        mockCalled = true
        integerForKeyCallsCount += 1
        integerForKeyReceivedKey = key
        integerForKeyReceivedInvocations.append(key)
        return integerForKeyClosure.map { $0(key) } ?? integerForKeyReturnValue
    }

    // MARK: - setInt

    var setIntForKeyCallsCount = 0
    var setIntForKeyCalled: Bool {
        setIntForKeyCallsCount > 0
    }

    var setIntForKeyReceivedArguments: (value: Int?, key: KeyValueStorageKey)?
    var setIntForKeyReceivedInvocations: [(value: Int?, key: KeyValueStorageKey)] = []
    var setIntForKeyClosure: ((Int?, KeyValueStorageKey) -> Void)?

    func setInt(_ value: Int?, forKey key: KeyValueStorageKey) {
        mockCalled = true
        setIntForKeyCallsCount += 1
        setIntForKeyReceivedArguments = (value: value, key: key)
        setIntForKeyReceivedInvocations.append((value: value, key: key))
        setIntForKeyClosure?(value, key)
    }

    // MARK: - double

    var doubleForKeyCallsCount = 0
    var doubleForKeyCalled: Bool {
        doubleForKeyCallsCount > 0
    }

    var doubleForKeyReceivedKey: KeyValueStorageKey?
    var doubleForKeyReceivedInvocations: [KeyValueStorageKey] = []
    var doubleForKeyReturnValue: Double?
    var doubleForKeyClosure: ((KeyValueStorageKey) -> Double?)?

    func double(forKey key: KeyValueStorageKey) -> Double? {
        mockCalled = true
        doubleForKeyCallsCount += 1
        doubleForKeyReceivedKey = key
        doubleForKeyReceivedInvocations.append(key)
        return doubleForKeyClosure.map { $0(key) } ?? doubleForKeyReturnValue
    }

    // MARK: - setDouble

    var setDoubleForKeyCallsCount = 0
    var setDoubleForKeyCalled: Bool {
        setDoubleForKeyCallsCount > 0
    }

    var setDoubleForKeyReceivedArguments: (value: Double?, key: KeyValueStorageKey)?
    var setDoubleForKeyReceivedInvocations: [(value: Double?, key: KeyValueStorageKey)] = []
    var setDoubleForKeyClosure: ((Double?, KeyValueStorageKey) -> Void)?

    func setDouble(_ value: Double?, forKey key: KeyValueStorageKey) {
        mockCalled = true
        setDoubleForKeyCallsCount += 1
        setDoubleForKeyReceivedArguments = (value: value, key: key)
        setDoubleForKeyReceivedInvocations.append((value: value, key: key))
        setDoubleForKeyClosure?(value, key)
    }

    // MARK: - string

    var stringForKeyCallsCount = 0
    var stringForKeyCalled: Bool {
        stringForKeyCallsCount > 0
    }

    var stringForKeyReceivedKey: KeyValueStorageKey?
    var stringForKeyReceivedInvocations: [KeyValueStorageKey] = []
    var stringForKeyReturnValue: String?
    var stringForKeyClosure: ((KeyValueStorageKey) -> String?)?

    func string(forKey key: KeyValueStorageKey) -> String? {
        mockCalled = true
        stringForKeyCallsCount += 1
        stringForKeyReceivedKey = key
        stringForKeyReceivedInvocations.append(key)
        return stringForKeyClosure.map { $0(key) } ?? stringForKeyReturnValue
    }

    // MARK: - setString

    var setStringForKeyCallsCount = 0
    var setStringForKeyCalled: Bool {
        setStringForKeyCallsCount > 0
    }

    var setStringForKeyReceivedArguments: (value: String?, key: KeyValueStorageKey)?
    var setStringForKeyReceivedInvocations: [(value: String?, key: KeyValueStorageKey)] = []
    var setStringForKeyClosure: ((String?, KeyValueStorageKey) -> Void)?

    func setString(_ value: String?, forKey key: KeyValueStorageKey) {
        mockCalled = true
        setStringForKeyCallsCount += 1
        setStringForKeyReceivedArguments = (value: value, key: key)
        setStringForKeyReceivedInvocations.append((value: value, key: key))
        setStringForKeyClosure?(value, key)
    }

    // MARK: - date

    var dateForKeyCallsCount = 0
    var dateForKeyCalled: Bool {
        dateForKeyCallsCount > 0
    }

    var dateForKeyReceivedKey: KeyValueStorageKey?
    var dateForKeyReceivedInvocations: [KeyValueStorageKey] = []
    var dateForKeyReturnValue: Date?
    var dateForKeyClosure: ((KeyValueStorageKey) -> Date?)?

    func date(forKey key: KeyValueStorageKey) -> Date? {
        mockCalled = true
        dateForKeyCallsCount += 1
        dateForKeyReceivedKey = key
        dateForKeyReceivedInvocations.append(key)
        return dateForKeyClosure.map { $0(key) } ?? dateForKeyReturnValue
    }

    // MARK: - setDate

    var setDateForKeyCallsCount = 0
    var setDateForKeyCalled: Bool {
        setDateForKeyCallsCount > 0
    }

    var setDateForKeyReceivedArguments: (value: Date?, key: KeyValueStorageKey)?
    var setDateForKeyReceivedInvocations: [(value: Date?, key: KeyValueStorageKey)] = []
    var setDateForKeyClosure: ((Date?, KeyValueStorageKey) -> Void)?

    func setDate(_ value: Date?, forKey key: KeyValueStorageKey) {
        mockCalled = true
        setDateForKeyCallsCount += 1
        setDateForKeyReceivedArguments = (value: value, key: key)
        setDateForKeyReceivedInvocations.append((value: value, key: key))
        setDateForKeyClosure?(value, key)
    }

    // MARK: - observeString

    var observeStringForKeyCallsCount = 0
    var observeStringForKeyCalled: Bool {
        observeStringForKeyCallsCount > 0
    }

    var observeStringForKeyReceivedKey: KeyValueStorageKey?
    var observeStringForKeyReceivedInvocations: [KeyValueStorageKey] = []
    var observeStringForKeyReturnValue: Observable<String>!
    var observeStringForKeyClosure: ((KeyValueStorageKey) -> Observable<String>)?

    func observeString(forKey key: KeyValueStorageKey) -> Observable<String> {
        mockCalled = true
        observeStringForKeyCallsCount += 1
        observeStringForKeyReceivedKey = key
        observeStringForKeyReceivedInvocations.append(key)
        return observeStringForKeyClosure.map { $0(key) } ?? observeStringForKeyReturnValue
    }

    // MARK: - deleteAll

    var deleteAllCallsCount = 0
    var deleteAllCalled: Bool {
        deleteAllCallsCount > 0
    }

    var deleteAllClosure: (() -> Void)?

    func deleteAll() {
        mockCalled = true
        deleteAllCallsCount += 1
        deleteAllClosure?()
    }
}

class LoginViewControllerDelegateMock: LoginViewControllerDelegate {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - userLoggedInSuccessfully

    var userLoggedInSuccessfullyCallsCount = 0
    var userLoggedInSuccessfullyCalled: Bool {
        userLoggedInSuccessfullyCallsCount > 0
    }

    var userLoggedInSuccessfullyClosure: (() -> Void)?

    func userLoggedInSuccessfully() {
        mockCalled = true
        userLoggedInSuccessfullyCallsCount += 1
        userLoggedInSuccessfullyClosure?()
    }
}

class LoginViewModelMock: LoginViewModel {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - loginUser

    var loginUserTokenCallsCount = 0
    var loginUserTokenCalled: Bool {
        loginUserTokenCallsCount > 0
    }

    var loginUserTokenReceivedToken: String?
    var loginUserTokenReceivedInvocations: [String] = []
    var loginUserTokenReturnValue: Single<Result<TokenExchangeResponseVo, HttpRequestError>>!
    var loginUserTokenClosure: ((String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>>)?

    func loginUser(token: String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>> {
        mockCalled = true
        loginUserTokenCallsCount += 1
        loginUserTokenReceivedToken = token
        loginUserTokenReceivedInvocations.append(token)
        return loginUserTokenClosure.map { $0(token) } ?? loginUserTokenReturnValue
    }
}

class NotificationCenterManagerMock: NotificationCenterManager {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - post

    var postExtrasCallsCount = 0
    var postExtrasCalled: Bool {
        postExtrasCallsCount > 0
    }

    var postExtrasReceivedArguments: (event: String, extras: [AnyHashable: Any]?)?
    var postExtrasReceivedInvocations: [(event: String, extras: [AnyHashable: Any]?)] = []
    var postExtrasClosure: ((String, [AnyHashable: Any]?) -> Void)?

    func post(_ event: String, extras: [AnyHashable: Any]?) {
        mockCalled = true
        postExtrasCallsCount += 1
        postExtrasReceivedArguments = (event: event, extras: extras)
        postExtrasReceivedInvocations.append((event: event, extras: extras))
        postExtrasClosure?(event, extras)
    }

    // MARK: - addObserver

    var addObserverSelectorNameCallsCount = 0
    var addObserverSelectorNameCalled: Bool {
        addObserverSelectorNameCallsCount > 0
    }

    var addObserverSelectorNameReceivedArguments: (observer: Any, selector: Selector, name: String)?
    var addObserverSelectorNameReceivedInvocations: [(observer: Any, selector: Selector, name: String)] = []
    var addObserverSelectorNameClosure: ((Any, Selector, String) -> Void)?

    func addObserver(_ observer: Any, selector: Selector, name: String) {
        mockCalled = true
        addObserverSelectorNameCallsCount += 1
        addObserverSelectorNameReceivedArguments = (observer: observer, selector: selector, name: name)
        addObserverSelectorNameReceivedInvocations.append((observer: observer, selector: selector, name: name))
        addObserverSelectorNameClosure?(observer, selector, name)
    }

    // MARK: - removeObserver

    var removeObserverNameCallsCount = 0
    var removeObserverNameCalled: Bool {
        removeObserverNameCallsCount > 0
    }

    var removeObserverNameReceivedArguments: (observer: Any, name: String)?
    var removeObserverNameReceivedInvocations: [(observer: Any, name: String)] = []
    var removeObserverNameClosure: ((Any, String) -> Void)?

    func removeObserver(_ observer: Any, name: String) {
        mockCalled = true
        removeObserverNameCallsCount += 1
        removeObserverNameReceivedArguments = (observer: observer, name: name)
        removeObserverNameReceivedInvocations.append((observer: observer, name: name))
        removeObserverNameClosure?(observer, name)
    }
}

class PendingTasksMock: PendingTasks {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - addDownloadNewFilesPendingTask

    var addDownloadNewFilesPendingTaskCallsCount = 0
    var addDownloadNewFilesPendingTaskCalled: Bool {
        addDownloadNewFilesPendingTaskCallsCount > 0
    }

    var addDownloadNewFilesPendingTaskReturnValue: Double!
    var addDownloadNewFilesPendingTaskClosure: (() -> Double)?

    func addDownloadNewFilesPendingTask() -> Double {
        mockCalled = true
        addDownloadNewFilesPendingTaskCallsCount += 1
        return addDownloadNewFilesPendingTaskClosure.map { $0() } ?? addDownloadNewFilesPendingTaskReturnValue
    }

    // MARK: - runAllTasks

    var runAllTasksCallsCount = 0
    var runAllTasksCalled: Bool {
        runAllTasksCallsCount > 0
    }

    var runAllTasksReturnValue: UIBackgroundFetchResult!
    var runAllTasksClosure: (() -> UIBackgroundFetchResult)?

    func runAllTasks() -> UIBackgroundFetchResult {
        mockCalled = true
        runAllTasksCallsCount += 1
        return runAllTasksClosure.map { $0() } ?? runAllTasksReturnValue
    }

    // MARK: - deleteAll

    var deleteAllCallsCount = 0
    var deleteAllCalled: Bool {
        deleteAllCallsCount > 0
    }

    var deleteAllClosure: (() -> Void)?

    func deleteAll() {
        mockCalled = true
        deleteAllCallsCount += 1
        deleteAllClosure?()
    }

    // MARK: - runCollectionTasks

    var runCollectionTasksForCallsCount = 0
    var runCollectionTasksForCalled: Bool {
        runCollectionTasksForCallsCount > 0
    }

    var runCollectionTasksForReceivedCollectionId: PendingTaskCollectionId?
    var runCollectionTasksForReceivedInvocations: [PendingTaskCollectionId] = []
    var runCollectionTasksForReturnValue: Single<RunCollectionTasksResult>!
    var runCollectionTasksForClosure: ((PendingTaskCollectionId) -> Single<RunCollectionTasksResult>)?

    func runCollectionTasks(for collectionId: PendingTaskCollectionId) -> Single<RunCollectionTasksResult> {
        mockCalled = true
        runCollectionTasksForCallsCount += 1
        runCollectionTasksForReceivedCollectionId = collectionId
        runCollectionTasksForReceivedInvocations.append(collectionId)
        return runCollectionTasksForClosure.map { $0(collectionId) } ?? runCollectionTasksForReturnValue
    }
}

class ReposRepositoryMock: ReposRepository {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - getUserRepos

    var getUserReposUsernameCallsCount = 0
    var getUserReposUsernameCalled: Bool {
        getUserReposUsernameCallsCount > 0
    }

    var getUserReposUsernameReceivedUsername: String?
    var getUserReposUsernameReceivedInvocations: [String] = []
    var getUserReposUsernameReturnValue: Single<Result<[Repo], HttpRequestError>>!
    var getUserReposUsernameClosure: ((String) -> Single<Result<[Repo], HttpRequestError>>)?

    func getUserRepos(username: String) -> Single<Result<[Repo], HttpRequestError>> {
        mockCalled = true
        getUserReposUsernameCallsCount += 1
        getUserReposUsernameReceivedUsername = username
        getUserReposUsernameReceivedInvocations.append(username)
        return getUserReposUsernameClosure.map { $0(username) } ?? getUserReposUsernameReturnValue
    }

    // MARK: - observeRepos

    var observeReposForUsernameCallsCount = 0
    var observeReposForUsernameCalled: Bool {
        observeReposForUsernameCallsCount > 0
    }

    var observeReposForUsernameReceivedForUsername: String?
    var observeReposForUsernameReceivedInvocations: [String] = []
    var observeReposForUsernameReturnValue: Observable<[Repo]>!
    var observeReposForUsernameClosure: ((String) -> Observable<[Repo]>)?

    func observeRepos(forUsername: String) -> Observable<[Repo]> {
        mockCalled = true
        observeReposForUsernameCallsCount += 1
        observeReposForUsernameReceivedForUsername = forUsername
        observeReposForUsernameReceivedInvocations.append(forUsername)
        return observeReposForUsernameClosure.map { $0(forUsername) } ?? observeReposForUsernameReturnValue
    }

    // MARK: - replaceRepos

    var replaceReposForUsernameThrowableError: Error?
    var replaceReposForUsernameCallsCount = 0
    var replaceReposForUsernameCalled: Bool {
        replaceReposForUsernameCallsCount > 0
    }

    var replaceReposForUsernameReceivedArguments: (repos: [Repo], forUsername: String)?
    var replaceReposForUsernameReceivedInvocations: [(repos: [Repo], forUsername: String)] = []
    var replaceReposForUsernameClosure: (([Repo], String) throws -> Void)?

    func replaceRepos(_ repos: [Repo], forUsername: String) throws {
        if let error = replaceReposForUsernameThrowableError {
            throw error
        }
        mockCalled = true
        replaceReposForUsernameCallsCount += 1
        replaceReposForUsernameReceivedArguments = (repos: repos, forUsername: forUsername)
        replaceReposForUsernameReceivedInvocations.append((repos: repos, forUsername: forUsername))
        try replaceReposForUsernameClosure?(repos, forUsername)
    }
}

class ReposViewModelMock: ReposViewModel {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    var gitHubUsername: GitHubUsername?

    // MARK: - observeRepos

    var observeReposCallsCount = 0
    var observeReposCalled: Bool {
        observeReposCallsCount > 0
    }

    var observeReposReturnValue: Observable<CacheState<[Repo]>>!
    var observeReposClosure: (() -> Observable<CacheState<[Repo]>>)?

    func observeRepos() -> Observable<CacheState<[Repo]>> {
        mockCalled = true
        observeReposCallsCount += 1
        return observeReposClosure.map { $0() } ?? observeReposReturnValue
    }

    // MARK: - observeGitHubUsername

    var observeGitHubUsernameCallsCount = 0
    var observeGitHubUsernameCalled: Bool {
        observeGitHubUsernameCallsCount > 0
    }

    var observeGitHubUsernameReturnValue: Observable<GitHubUsername>!
    var observeGitHubUsernameClosure: (() -> Observable<GitHubUsername>)?

    func observeGitHubUsername() -> Observable<GitHubUsername> {
        mockCalled = true
        observeGitHubUsernameCallsCount += 1
        return observeGitHubUsernameClosure.map { $0() } ?? observeGitHubUsernameReturnValue
    }
}

class RepositorySyncServiceMock: RepositorySyncService {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - syncAll

    var syncAllOnCompleteCallsCount = 0
    var syncAllOnCompleteCalled: Bool {
        syncAllOnCompleteCallsCount > 0
    }

    var syncAllOnCompleteReceivedOnComplete: (([RefreshResult]) -> Void)?
    var syncAllOnCompleteReceivedInvocations: [([RefreshResult]) -> Void] = []
    var syncAllOnCompleteClosure: ((@escaping ([RefreshResult]) -> Void) -> Void)?

    func syncAll(onComplete: @escaping ([RefreshResult]) -> Void) {
        mockCalled = true
        syncAllOnCompleteCallsCount += 1
        syncAllOnCompleteReceivedOnComplete = onComplete
        syncAllOnCompleteReceivedInvocations.append(onComplete)
        syncAllOnCompleteClosure?(onComplete)
    }

    // MARK: - refreshRepos

    var refreshReposOnCompleteCallsCount = 0
    var refreshReposOnCompleteCalled: Bool {
        refreshReposOnCompleteCallsCount > 0
    }

    var refreshReposOnCompleteReceivedOnComplete: ((RefreshResult) -> Void)?
    var refreshReposOnCompleteReceivedInvocations: [(RefreshResult) -> Void] = []
    var refreshReposOnCompleteClosure: ((@escaping (RefreshResult) -> Void) -> Void)?

    func refreshRepos(onComplete: @escaping (RefreshResult) -> Void) {
        mockCalled = true
        refreshReposOnCompleteCallsCount += 1
        refreshReposOnCompleteReceivedOnComplete = onComplete
        refreshReposOnCompleteReceivedInvocations.append(onComplete)
        refreshReposOnCompleteClosure?(onComplete)
    }
}

class UserManagerMock: UserManager {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    var userId: Double?
    var authToken: String?
    var underlyingIsLoggedIn: Bool!
    var isLoggedInCalled = false
    var isLoggedInGetCalled = false
    var isLoggedInSetCalled = false
    var isLoggedIn: Bool {
        get {
            mockCalled = true
            isLoggedInCalled = true
            isLoggedInGetCalled = true
            return underlyingIsLoggedIn
        }
        set(value) {
            mockCalled = true
            isLoggedInCalled = true
            isLoggedInSetCalled = true
            underlyingIsLoggedIn = value
        }
    }

    // MARK: - logout

    var logoutCallsCount = 0
    var logoutCalled: Bool {
        logoutCallsCount > 0
    }

    var logoutClosure: (() -> Void)?

    func logout() {
        mockCalled = true
        logoutCallsCount += 1
        logoutClosure?()
    }
}

class UserRepositoryMock: UserRepository {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - exchangeToken

    var exchangeTokenCallsCount = 0
    var exchangeTokenCalled: Bool {
        exchangeTokenCallsCount > 0
    }

    var exchangeTokenReceivedToken: String?
    var exchangeTokenReceivedInvocations: [String] = []
    var exchangeTokenReturnValue: Single<Result<TokenExchangeResponseVo, HttpRequestError>>!
    var exchangeTokenClosure: ((String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>>)?

    func exchangeToken(_ token: String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>> {
        mockCalled = true
        exchangeTokenCallsCount += 1
        exchangeTokenReceivedToken = token
        exchangeTokenReceivedInvocations.append(token)
        return exchangeTokenClosure.map { $0(token) } ?? exchangeTokenReturnValue
    }
}
