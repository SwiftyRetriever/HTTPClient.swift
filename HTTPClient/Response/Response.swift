//
//  Response.swift
//  HTTPClient
//
//  Created by 张伟 on 2018/12/12.
//  Copyright © 2018 zevwings. All rights reserved.
//

public final class Response: Equatable {
    
    public let statusCode: Int
    
    public let data: Data?
    
    public let request: URLRequest?
    
    public let response: HTTPURLResponse?
    
    public let timeline: Timeline?
    
    public init(statusCode: Int, data: Data?, request: URLRequest?, response: HTTPURLResponse?, timeline: Timeline?) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.response = response
        self.timeline = timeline
    }
    
    public static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.statusCode == rhs.statusCode &&
            lhs.data == rhs.data &&
            lhs.response == rhs.response
    }
}

extension Response {
    
    /// 校验statusCode是否为所需要的statusCode
    ///
    /// - Parameter acceptableStatusCodes: 正确的statusCode
    /// - Returns: Response
    /// - Throws: HTTPError
    public func validate<S>(statusCode acceptableStatusCodes: S) throws -> Self where S : Sequence, S.Element == Int {
        guard acceptableStatusCodes.contains(statusCode) else {
            throw HTTPError.validation(statusCode: statusCode, request: request, response: response)
        }
        return self
    }
    
    /// 校验statusCode是否为所需要的statusCode
    ///
    /// - Parameter validateType: 校验类型 @see ValidationType
    /// - Returns: Response
    /// - Throws: HTTPError
    public func validate(_ validateType: ValidationType) throws -> Self {
        return try validate(statusCode: validateType.statusCodes)
    }
}

extension Response {
    
    ///将Response中的数据转换成图片
    ///
    /// - Returns: 图片数据
    /// - Throws: HTTPError
    public func mapImage() throws -> UIImage {
        guard let data = data, !data.isEmpty else {
            throw HTTPError.emptyResponse(request: request, response: response)
        }
        guard let image = UIImage(data: data) else {
            throw HTTPError.emptyResponse(request: request, response: response)
        }
        return image
    }
    
    ///将Response中的数据转换成JSON
    ///
    /// - Returns: JSON数据
    /// - Throws: HTTPError
    public func mapJSON() throws -> Any {
        guard let data = data, !data.isEmpty else {
            throw HTTPError.emptyResponse(request: request, response: response)
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            throw HTTPError.underlying(error, request: request, response: response)
        }
    }
    
    ///将Response中的数据转换成String
    ///
    /// - Parameter keyPath: 字典中对应的Key
    /// - Returns: String数据
    /// - Throws: HTTPError
    public func mapString(atKeyPath keyPath: String? = nil) throws -> String {
        guard let data = data, !data.isEmpty else {
            throw HTTPError.emptyResponse(request: request, response: response)
        }
        guard let string = String(data: data, encoding: .utf8) else {
            throw HTTPError.emptyResponse(request: request, response: response)
        }
        return string
    }
    
    /// 将数据转换为`Model`
    ///
    /// - Parameters:
    ///   - type: 数据类型
    ///   - keyPath: 字典中对应的Key
    ///   - transformer: 转换器，转换规则
    /// - Returns: Model数据
    /// - Throws: HTTPError
    public func map<T>(to type: T.Type,
                       atKeyPath keyPath: String? = nil,
                       transformer: Transformer = CommonTransformer()) throws -> T where T: Model {
        do {
            let result = try transformer.transform(self)
            return try T.transform(result, atKeyPath: keyPath)
        } catch {
            throw HTTPError.underlying(error, request: request, response: response)
        }
    }
}

extension Response: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return """
        ============================================================
        网络请求结果
        Service: \(request?.service ?? "")
        Path: \(request?.url?.path ?? "")
        StatusCode: \(statusCode)
        \(timeline == nil ? "" : timeline!.description)
        Data: \(data?.count ?? 0) Bytes
        ============================================================
        """
    }
    
    public var debugDescription: String {
        return description
    }
}

// MARK: - URLRequest

extension URLRequest {
    var service: String {
        var service = ""
        if let scheme = url?.scheme {
            service.append(scheme)
            service.append("://")
        }
        if let host = url?.host {
            service.append(host)
        }
        return service
    }
}
