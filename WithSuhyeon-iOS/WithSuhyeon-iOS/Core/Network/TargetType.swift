//
//  TargetType.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation

import Alamofire

public protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParameters { get }
    var headers: [String: String]? { get }
    var multipartFormData: ((MultipartFormData) -> Void)? { get }}

public extension TargetType {
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var multipartFormData: ((MultipartFormData) -> Void)? {
        return nil
    }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        if let headers = headers {
            urlRequest.headers = HTTPHeaders(headers)
        }
        
        switch parameters {
        case .none:
            break
            
        case .query(let request):
            if let dictionary = request?.toDictionary() {
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: dictionary)
            }
            
        case .body(let request):
            if let dictionary = request?.toDictionary() {
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: dictionary)
            }
        }
        
        return urlRequest
    }
}
