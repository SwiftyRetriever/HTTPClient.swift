//
//  CommonTransformer.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

/** 基本返回数据模型
 ```
 {
    code:200,
    description: "请求成功"
    model: {
        success: "0",
        respMsg: "请求业务类型正确"
        ...
        其他参数
        ····
    }
 }
 ```
 */
public struct BasicModel {
    
    public struct Body {
        public static let code = "code"
        public static let message = "description"
        public static let model = "model"
    }
    
    public struct Model {
        public static let code = "success"
        public static let message = "respMsg"
    }
}

public final class CommonTransformer: Transformer {
    
    public init() {}
    
    public func transform(_ response: Response) throws -> Any {
        
        /// 校验response的statuscode是否为2xx和3xx
        let _response: Response
        do {
            _response = try response.validate(.successAndRedirectCodes)
        } catch {
            throw TransformerError.statusCode
        }
        
        guard let jsonObject = try _response.mapJSON() as? [String: Any] else {
            throw TransformerError.emptyResponse
        }
        
        /// 检验返回体中`code`是否为成功
        let bodyCode = try codeValue(from: jsonObject[BasicModel.Body.code])
        let bodyMsg = jsonObject[BasicModel.Body.message] as? String
        guard bodyCode == 200 else {
            throw TransformerError.server(code: bodyCode, message: bodyMsg)
        }
        
        /// 检验返回体中`model`是否为空
        guard let model = jsonObject[BasicModel.Body.model] as? [String: Any] else {
            throw TransformerError.modelDeficiency
        }
        
        /// 检查`model.success`是否为成功
        let modelCode = try codeValue(from: model[BasicModel.Model.code])
        let modelMsg = model[BasicModel.Model.message] as? String
        guard modelCode == 0 else {
            throw TransformerError.business(code: bodyCode, message: modelMsg)
        }
        
        return model
    }
    
    /// 根据返回Code转换为Int类型
    ///
    /// - Parameter value: 服务器返回Code
    /// - Returns: Int类型的Code
    private func codeValue(from value: Any?) throws -> Int {
        
        if let strCode = value as? String, let code = Int(strCode) {
            return code
        } else if let code = value as? Int {
            return code
        } else {
            throw TransformerError.invalidResponseBody
        }
    }
}

// MARK: - ResponseError

public enum TransformerError: Error {
    case statusCode
    case emptyResponse
    case server(code: Int, message: String?)
    case business(code: Int, message: String?)
    case modelDeficiency
    case invalidResponseBody
}

extension TransformerError: LocalizedError {
    
    private var defaultErrorMessage: String {
        return "服务器返回数据错误"
    }
    
    public var errorDescription: String? {
        
        switch self {
        case .statusCode, .emptyResponse, .modelDeficiency, .invalidResponseBody:
            return defaultErrorMessage
        case .server(_, let message):
            return message ?? defaultErrorMessage
        case .business(_, let message):
            return message ?? defaultErrorMessage
        }
    }
}

extension TransformerError: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        switch self {
        case .statusCode:
            return "校验网络返回数据错误，StatusCode不为2xx或3xx"
        case .emptyResponse:
            return "请求返回转换错误，返回数据不能转化为基本字典模型 [Srting: Any]"
        case .server(let code, let message):
            return "服务器返回数据错误，Code：\(code)，Message \(message ?? defaultErrorMessage)"
        case .business(let code, let message):
            return "业务逻辑错误，Code：\(code)，Message \(message ?? defaultErrorMessage)"
        case .modelDeficiency:
            return "返回`model`数据为空，或者`model`数据不能转化为基本字典模型 [Srting: Any]"
        case .invalidResponseBody:
            return "返回数据缺失，不存在`model.success`或者`code`"
        }
    }
    
    public var debugDescription: String {
        return description
    }
}

