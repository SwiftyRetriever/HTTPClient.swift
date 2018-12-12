//
//  Single+Response.swift
//  RxHTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import RxSwift
#if !COCOAPODS
import HTTPClient
#endif

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func validate<S>(statusCode acceptableStatusCodes: S) -> Single<ElementType> where S : Sequence, S.Element == Int {
        return flatMap { .just(try $0.validate(statusCode: acceptableStatusCodes)) }
    }
    
    public func validate(_ validateType: ValidationType) -> Single<ElementType> {
        return flatMap { .just(try $0.validate(validateType)) }
    }
    
    public func mapImage() -> Single<UIImage> {
        return flatMap { .just(try $0.mapImage()) }
    }
    
    public func mapJSON() -> Single<Any> {
        return flatMap { .just(try $0.mapJSON()) }
    }
    
    public func mapString(atKeyPath keyPath: String? = nil) -> Single<String> {
        return flatMap { .just(try $0.mapString(atKeyPath: keyPath)) }
    }
    
    public func map<T>(to type: T.Type, atKeyPath keyPath: String? = nil, transformer: Transformer = CommonTransformer()) -> Single<T> where T: Model {
        return flatMap { .just(try $0.map(to: type, atKeyPath: keyPath, transformer: transformer)) }
    }
}

