//
//  HTTPError.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

public enum HTTPError: Error {
    
    case invalidUrl(service: String, path: String)
    
    case invalidParameters(service: String, path: String, paramters: Parameters?, error: Error)
    
    case request(service: String, path: String, error: Error)

    case upload(service: String, path: String, error: Swift.Error?)
    
    case emptyResponse(request: URLRequest?, response: HTTPURLResponse?)
    
    case timeout(request: URLRequest?, response: HTTPURLResponse?)
    
    case connectionLost(request: URLRequest?, response: HTTPURLResponse?)
    
    case validation(statusCode: Int, request: URLRequest?, response: HTTPURLResponse?)
    
    case underlying(Swift.Error, request: URLRequest?, response: HTTPURLResponse?)
    
}

extension HTTPError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidUrl, .request:
            return "网络请求失败"
        case .invalidParameters(_, _, _, let error):
            return errorHandler(error: error, defaultMessage: "网络请求失败")
        case .upload:
            return "上传文件错误"
        case .emptyResponse, .validation:
            return "服务器返回错误"
        case .timeout:
            return "网络请求超时\n请检查网络是否正常"
        case .connectionLost:
            return "网络链接错误\n请检查网络是否正常"
        case .underlying(let error, _, _):
            return errorHandler(error: error, defaultMessage: "网络错误")
        }
    }
    
    func errorHandler(error: Error, defaultMessage message: String) -> String {
        if error is LocalizedError {
            return error.localizedDescription
        } else {
            return message
        }
    }
}

extension HTTPError: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        switch self {
        case .invalidUrl(let service, let path):
            return """
            ============================================================
            生成网络请求失败：不合法得URL
            Service: \(service)
            Path: \(path)
            ============================================================
            """
        case .invalidParameters(let service, let path, let paramters, let error):
            return """
            ============================================================
            生成网络请求失败：参数校验失败
            Service: \(service)
            Path: \(path)
            Parameters: \(paramters ?? [:])
            Error: \(error)
            ============================================================
            """
        case .request(let service, let path, let error):
            return """
            ============================================================
            生成网络请求失败：构建URLRequest失败
            Service: \(service)
            Path: \(path)
            Error: \(error)
            ============================================================
            """
        case .upload(let service, let path, let error):
            return """
            ============================================================
            上传文件错误，请检查上传内容是否正确
            Service: \(service)
            Path: \(path)
            Error: \(String(describing: error))
            ============================================================
            """
        case .emptyResponse(let request, _):
            return """
            ============================================================
            数据返回内容为空或者无法转换为[String:Any]格式
            Service: \(request?.service ?? "")
            Path: \(request?.url?.path ?? "")
            ============================================================
            """
        case .timeout(let request, _):
            return """
            ============================================================
            网络请求超时，请检查网络是否正常
            Service: \(request?.service ?? "")
            Path: \(request?.url?.path ?? "")
            ============================================================
            """
        case .connectionLost(let request, _):
            return """
            ============================================================
            网络连接失败，请检查网络是否正常
            Service: \(request?.service ?? "")
            Path: \(request?.url?.path ?? "")
            ============================================================
            """
        case .validation(let statusCode, let request, _):
            return """
            ============================================================
            网络返回数据校验失败
            Service: \(request?.service ?? "")
            Path: \(request?.url?.path ?? "")
            StatusCode: \(statusCode)
            ============================================================
            """
        case .underlying(let error, let request, _):
            return """
            ============================================================
            网络错误，具体错误信息如下
            Service: \(request?.service ?? "")
            Path: \(request?.url?.path ?? "")
            Error: \(error)
            ============================================================
            """
        }
    }
    
    public var debugDescription: String {
        return description
    }
}
