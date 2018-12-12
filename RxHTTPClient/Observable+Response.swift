//
//  Observable+Response.swift
//  RxHTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import RxSwift
#if !COCOAPODS
import HTTPClient
#endif

extension ObservableType where E == Response {
    
    public func validate<S>(statusCode acceptableStatusCodes: S) -> Observable<E> where S : Sequence, S.Element == Int {
        return flatMap { Observable.just(try $0.validate(statusCode: acceptableStatusCodes)) }
    }
    
    public func validate(_ validateType: ValidationType) -> Observable<E> {
        return flatMap { Observable.just( try $0.validate(validateType) ) }
    }
    
    public func mapImage() -> Observable<UIImage> {
        return flatMap { Observable.just( try $0.mapImage()) }
    }
    
    internal func mapJSON() -> Observable<Any> {
        return flatMap { Observable.just( try $0.mapJSON()) }
    }
    
    public func mapString(atKeyPath keyPath: String? = nil) -> Observable<String> {
        return flatMap { Observable.just( try $0.mapString(atKeyPath: keyPath)) }
    }
    
    public func map<T>(to type: T.Type, atKeyPath keyPath: String? = nil, validator: ResponseValidator = CommonResponseValidator()) -> Observable<T> where T: Model {
        return flatMap { Observable.just(try $0.map(to: type, atKeyPath: keyPath, validator: validator)) }
    }
}

