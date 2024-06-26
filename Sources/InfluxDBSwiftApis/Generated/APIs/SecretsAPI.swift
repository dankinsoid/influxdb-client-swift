//
// SecretsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import InfluxDBSwift

extension InfluxDB2API {


public struct SecretsAPI {
    private let influxDB2API: InfluxDB2API

    public init(influxDB2API: InfluxDB2API) {
        self.influxDB2API = influxDB2API
    }

    /**
     Delete a secret from an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter secretID: (path) The secret ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func deleteOrgsIDSecretsID(orgID: String, secretID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        deleteOrgsIDSecretsIDWithRequestBuilder(orgID: orgID, secretID: secretID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Delete a secret from an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter secretID: (path) The secret ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func deleteOrgsIDSecretsID(orgID: String, secretID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Void? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void?, Error>) -> Void in
            deleteOrgsIDSecretsIDWithRequestBuilder(orgID: orgID, secretID: secretID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Delete a secret from an organization
     - DELETE /orgs/{orgID}/secrets/{secretID}
     - parameter orgID: (path) The organization ID. 
     - parameter secretID: (path) The secret ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func deleteOrgsIDSecretsIDWithRequestBuilder(orgID: String, secretID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/orgs/{orgID}/secrets/{secretID}"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let secretIDPreEscape = "\(APIHelper.mapValueToPathItem(secretID))"
        let secretIDPostEscape = secretIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{secretID}", with: secretIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void> = influxDB2API.requestBuilderFactory.getRequestNonDecodableBuilder(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     List all secret keys for an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getOrgsIDSecrets(orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: SecretKeysResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getOrgsIDSecretsWithRequestBuilder(orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     List all secret keys for an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getOrgsIDSecrets(orgID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> SecretKeysResponse? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<SecretKeysResponse?, Error>) -> Void in
            getOrgsIDSecretsWithRequestBuilder(orgID: orgID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response.body)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     List all secret keys for an organization
     - GET /orgs/{orgID}/secrets
     - parameter orgID: (path) The organization ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<SecretKeysResponse> 
     */
    internal func getOrgsIDSecretsWithRequestBuilder(orgID: String, zapTraceSpan: String? = nil) -> RequestBuilder<SecretKeysResponse> {
        var path = "/orgs/{orgID}/secrets"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<SecretKeysResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Update secrets in an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter requestBody: (body) Secret key value pairs to update/add 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func patchOrgsIDSecrets(orgID: String, requestBody: [String: String], zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        patchOrgsIDSecretsWithRequestBuilder(orgID: orgID, requestBody: requestBody, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Update secrets in an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter requestBody: (body) Secret key value pairs to update/add 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func patchOrgsIDSecrets(orgID: String, requestBody: [String: String], zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Void? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void?, Error>) -> Void in
            patchOrgsIDSecretsWithRequestBuilder(orgID: orgID, requestBody: requestBody, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Update secrets in an organization
     - PATCH /orgs/{orgID}/secrets
     - parameter orgID: (path) The organization ID. 
     - parameter requestBody: (body) Secret key value pairs to update/add 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func patchOrgsIDSecretsWithRequestBuilder(orgID: String, requestBody: [String: String], zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/orgs/{orgID}/secrets"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: requestBody)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void> = influxDB2API.requestBuilderFactory.getRequestNonDecodableBuilder(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Delete secrets from an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter secretKeys: (body) Secret key to delete 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(*, deprecated, message: "This operation is deprecated.")
    public func postOrgsIDSecrets(orgID: String, secretKeys: SecretKeys, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postOrgsIDSecretsWithRequestBuilder(orgID: orgID, secretKeys: secretKeys, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    #if swift(>=5.5)
    /**
     Delete secrets from an organization
     
     - parameter orgID: (path) The organization ID. 
     - parameter secretKeys: (body) Secret key to delete 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(*, deprecated, message: "This operation is deprecated.")
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func postOrgsIDSecrets(orgID: String, secretKeys: SecretKeys, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> Void? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void?, Error>) -> Void in
            postOrgsIDSecretsWithRequestBuilder(orgID: orgID, secretKeys: secretKeys, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    #endif

    /**
     Delete secrets from an organization
     - POST /orgs/{orgID}/secrets/delete
     - parameter orgID: (path) The organization ID. 
     - parameter secretKeys: (body) Secret key to delete 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    @available(*, deprecated, message: "This operation is deprecated.")
    internal func postOrgsIDSecretsWithRequestBuilder(orgID: String, secretKeys: SecretKeys, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/orgs/{orgID}/secrets/delete"
        let orgIDPreEscape = "\(APIHelper.mapValueToPathItem(orgID))"
        let orgIDPostEscape = orgIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{orgID}", with: orgIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: secretKeys)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void> = influxDB2API.requestBuilderFactory.getRequestNonDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

}
}
