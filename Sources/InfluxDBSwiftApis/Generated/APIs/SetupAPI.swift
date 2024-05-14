//
// SetupAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import InfluxDBSwift

extension InfluxDB2API {


public struct SetupAPI {
    private let influxDB2API: InfluxDB2API

    public init(influxDB2API: InfluxDB2API) {
        self.influxDB2API = influxDB2API
    }

    /**
     Check if database has default user, org, bucket
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getSetup(zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: IsOnboarding?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getSetupWithRequestBuilder(zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Check if database has default user, org, bucket
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getSetup(zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> IsOnboarding? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<IsOnboarding?, Error>) -> Void in
            getSetupWithRequestBuilder(zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Check if database has default user, org, bucket
     - GET /setup
     - Returns `true` if no default user, organization, or bucket has been created.
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<IsOnboarding> 
     */
    internal func getSetupWithRequestBuilder(zapTraceSpan: String? = nil) -> RequestBuilder<IsOnboarding> {
        let path = "/setup"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<IsOnboarding> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Set up initial user, org and bucket
     
     - parameter onboardingRequest: (body) Source to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postSetup(onboardingRequest: OnboardingRequest, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: OnboardingResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postSetupWithRequestBuilder(onboardingRequest: onboardingRequest, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Set up initial user, org and bucket
     
     - parameter onboardingRequest: (body) Source to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func postSetup(onboardingRequest: OnboardingRequest, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil) async throws -> OnboardingResponse? {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<OnboardingResponse?, Error>) -> Void in
            postSetupWithRequestBuilder(onboardingRequest: onboardingRequest, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
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
     Set up initial user, org and bucket
     - POST /setup
     - Post an onboarding request to set up initial user, org and bucket.
     - parameter onboardingRequest: (body) Source to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<OnboardingResponse> 
     */
    internal func postSetupWithRequestBuilder(onboardingRequest: OnboardingRequest, zapTraceSpan: String? = nil) -> RequestBuilder<OnboardingResponse> {
        let path = "/setup"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: onboardingRequest)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<OnboardingResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

}
}
