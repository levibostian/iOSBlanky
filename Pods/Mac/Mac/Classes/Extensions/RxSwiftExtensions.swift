//
//  RxSwiftExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation
import RxSwift

public extension PrimitiveSequence {
    
    public func subscribeCompletable(_ onCompleted: @escaping () -> (), onError: @escaping (Error) -> ()) -> Disposable {
        var stopped = false
        return self.primitiveSequence.asObservable().subscribe { event in
            if stopped { return }
            stopped = true
            
            switch event {
            case .next(_):
                fatalError("Hit next. This should never happen on a Completable.")
            case .error(let error):
                onError(error)
            case .completed:
                onCompleted()
            }
        }
    }
    
    public func subscribeSingle(_ onNext: @escaping (ElementType) -> (), onError: @escaping (Error) -> ()) -> Disposable {
        var stopped = false
        return self.primitiveSequence.asObservable().subscribe { event in
            if stopped { return }
            stopped = true
            
            switch event {
            case .next(let element):
                onNext(element)
            case .error(let error):
                onError(error)
            case .completed:
                fatalError("Hit completed. This should never happen on a Single.")
            }
        }
    }
    
}
