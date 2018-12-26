//
//  Model.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

import HandyJSON

public typealias JSON = [String: Any]

public enum ModelError: Error {
    case cast(value: Any?, targetType: Any.Type)
}

public protocol Model {
    
    /// 将返回的JSON对象转化为`Model`对象
    ///
    /// - Parameter response: JSON对象
    /// - Parameter elementKey: 返回结果对象对应的Key
    /// - Returns: `ResponseTransformer`对象
    /// - Throws: ModelError 返回错误
    static func transform(_ value: Any, atKeyPath keyPath: String?) throws -> Self
    
}

// MARK: - 为`String`实现`Model`协议
extension String: Model {
    
    public static func transform(_ value: Any, atKeyPath keyPath: String?) throws -> String {
        
        if let value = value as? JSON {
            guard let keyPath = keyPath, let result = value[keyPath] as? String else {
                throw ModelError.cast(value: value, targetType: String.self)
            }
            return result
        } else {
            guard let result = value as? String else {
                throw ModelError.cast(value: value, targetType: String.self)
            }
            return result
        }
    }
}

// MARK: - 为`Dictionary`实现`Model`协议
extension Dictionary : Model where Key == String, Value == Any {
    
    public static func transform(_ value: Any, atKeyPath keyPath: String?) throws -> Dictionary<Key, Value> {
        
        if let value = value as? JSON {
            if let keyPath = keyPath {
                guard let result = value[keyPath] as? JSON else {
                    throw ModelError.cast(value: value, targetType: JSON.self)
                }
                return result
            } else {
                return value
            }
        } else {
            throw ModelError.cast(value: value, targetType: JSON.self)
        }
    }
}

// MARK: - 为`HandyJSON`实现`Model`协议
extension HandyJSON where Self: Model {
    
    public static func transform(_ value: Any, atKeyPath keyPath: String?) throws -> Self {
        
        if let value = value as? JSON {
            if let keyPath = keyPath {
                guard let v = value[keyPath] as? JSON, let result = deserialize(from: v) else {
                    throw ModelError.cast(value: value, targetType: HandyJSON.self)
                }
                return result
            } else {
                guard let result = deserialize(from: value) else {
                    throw ModelError.cast(value: value, targetType: HandyJSON.self)
                }
                return result
            }
        } else {
            throw ModelError.cast(value: value, targetType: JSON.self)
        }
    }
}

// MARK: - 为`Array`实现`Model`协议
extension Array : Model where Element: HandyJSON, Element: Model {
    
    public static func transform(_ value: Any, atKeyPath keyPath: String?) throws -> Array<Element> {
        
        if let value = value as? JSON, let keyPath = keyPath {
            guard let v = value[keyPath] as? [JSON], let result = [Element].deserialize(from: v) as? [Element]else {
                throw ModelError.cast(value: value, targetType: HandyJSON.self)
            }
            return result
        } else {
            guard let v = value as? [JSON], let result = [Element].deserialize(from: v) as? [Element]else {
                throw ModelError.cast(value: value, targetType: HandyJSON.self)
            }
            return result
        }
    }
}

// MARK: - ModelError

extension ModelError: LocalizedError, CustomDebugStringConvertible {
    
    public var errorDescription: String? {
        return "服务器返回错误"
    }
    
    public var description: String {
        switch self {
        case .cast(let value, let targetType):
            return "HTTPKit Cannot cast value : \(value ?? "") to targetType: \(targetType)"
        }
    }
    
    public var debugDescription: String {
        return description
    }
}

// MARK: - None

/// 没有返回值，只校验必须参数
public struct None: HandyJSON, Model {
    public init () {}
}

extension None: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "None"
    }
    
    public var debugDescription: String {
        return description
    }
}

