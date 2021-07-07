//
// UsersAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import InfluxDBSwift

extension InfluxDB2API {


public class UsersAPI {
    private let influxDB2API: InfluxDB2API

    public init(influxDB2API: InfluxDB2API) {
        self.influxDB2API = influxDB2API
    }

    /**
     Delete a user
     
     - parameter userID: (path) The ID of the user to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func deleteUsersID(userID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        deleteUsersIDWithRequestBuilder(userID: userID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Delete a user
     - DELETE /users/{userID}
     - parameter userID: (path) The ID of the user to delete. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func deleteUsersIDWithRequestBuilder(userID: String, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/users/{userID}"
        let userIDPreEscape = "\(APIHelper.mapValueToPathItem(userID))"
        let userIDPostEscape = userIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userID}", with: userIDPostEscape, options: .literal, range: nil)
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
     Return the feature flags for the currently authenticated user
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getFlags(zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: [String: Any]?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getFlagsWithRequestBuilder(zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Return the feature flags for the currently authenticated user
     - GET /flags
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<[String: String]> 
     */
    internal func getFlagsWithRequestBuilder(zapTraceSpan: String? = nil) -> RequestBuilder<[String: String]> {
        let path = "/flags"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<[String: String]> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Retrieve the currently authenticated user
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getMe(zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: UserResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getMeWithRequestBuilder(zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Retrieve the currently authenticated user
     - GET /me
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<UserResponse> 
     */
    internal func getMeWithRequestBuilder(zapTraceSpan: String? = nil) -> RequestBuilder<UserResponse> {
        let path = "/me"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<UserResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     List all users
     
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter offset: (query)  (optional)
     - parameter limit: (query)  (optional, default to 20)
     - parameter after: (query) The last resource ID from which to seek from (but not including). This is to be used instead of &#x60;offset&#x60;.  (optional)
     - parameter name: (query)  (optional)
     - parameter id: (query)  (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getUsers(zapTraceSpan: String? = nil, offset: Int? = nil, limit: Int? = nil, after: String? = nil, name: String? = nil, id: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Users?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getUsersWithRequestBuilder(zapTraceSpan: zapTraceSpan, offset: offset, limit: limit, after: after, name: name, id: id).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     List all users
     - GET /users
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter offset: (query)  (optional)
     - parameter limit: (query)  (optional, default to 20)
     - parameter after: (query) The last resource ID from which to seek from (but not including). This is to be used instead of &#x60;offset&#x60;.  (optional)
     - parameter name: (query)  (optional)
     - parameter id: (query)  (optional)
     - returns: RequestBuilder<Users> 
     */
    internal func getUsersWithRequestBuilder(zapTraceSpan: String? = nil, offset: Int? = nil, limit: Int? = nil, after: String? = nil, name: String? = nil, id: String? = nil) -> RequestBuilder<Users> {
        let path = "/users"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "offset": offset?.encodeToJSON(), 
            "limit": limit?.encodeToJSON(), 
            "after": after?.encodeToJSON(), 
            "name": name?.encodeToJSON(), 
            "id": id?.encodeToJSON()
        ])
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Users> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Retrieve a user
     
     - parameter userID: (path) The user ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func getUsersID(userID: String, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: UserResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        getUsersIDWithRequestBuilder(userID: userID, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Retrieve a user
     - GET /users/{userID}
     - parameter userID: (path) The user ID. 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<UserResponse> 
     */
    internal func getUsersIDWithRequestBuilder(userID: String, zapTraceSpan: String? = nil) -> RequestBuilder<UserResponse> {
        var path = "/users/{userID}"
        let userIDPreEscape = "\(APIHelper.mapValueToPathItem(userID))"
        let userIDPostEscape = userIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userID}", with: userIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<UserResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Update a user
     
     - parameter userID: (path) The ID of the user to update. 
     - parameter user: (body) User update to apply 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func patchUsersID(userID: String, user: User, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: UserResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        patchUsersIDWithRequestBuilder(userID: userID, user: user, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Update a user
     - PATCH /users/{userID}
     - parameter userID: (path) The ID of the user to update. 
     - parameter user: (body) User update to apply 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<UserResponse> 
     */
    internal func patchUsersIDWithRequestBuilder(userID: String, user: User, zapTraceSpan: String? = nil) -> RequestBuilder<UserResponse> {
        var path = "/users/{userID}"
        let userIDPreEscape = "\(APIHelper.mapValueToPathItem(userID))"
        let userIDPostEscape = userIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userID}", with: userIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: user)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<UserResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Create a user
     
     - parameter user: (body) User to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postUsers(user: User, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: UserResponse?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postUsersWithRequestBuilder(user: user, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Create a user
     - POST /users
     - parameter user: (body) User to create 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<UserResponse> 
     */
    internal func postUsersWithRequestBuilder(user: User, zapTraceSpan: String? = nil) -> RequestBuilder<UserResponse> {
        let path = "/users"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: user)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<UserResponse> = influxDB2API.requestBuilderFactory.getRequestDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Update a password
     
     - parameter userID: (path) The user ID. 
     - parameter passwordResetBody: (body) New password 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func postUsersIDPassword(userID: String, passwordResetBody: PasswordResetBody, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        postUsersIDPasswordWithRequestBuilder(userID: userID, passwordResetBody: passwordResetBody, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Update a password
     - POST /users/{userID}/password
     - BASIC:
       - type: http
       - name: BasicAuth
     - parameter userID: (path) The user ID. 
     - parameter passwordResetBody: (body) New password 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func postUsersIDPasswordWithRequestBuilder(userID: String, passwordResetBody: PasswordResetBody, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        var path = "/users/{userID}/password"
        let userIDPreEscape = "\(APIHelper.mapValueToPathItem(userID))"
        let userIDPostEscape = userIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userID}", with: userIDPostEscape, options: .literal, range: nil)
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: passwordResetBody)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void> = influxDB2API.requestBuilderFactory.getRequestNonDecodableBuilder(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

    /**
     Update a password
     
     - parameter passwordResetBody: (body) New password 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    public func putMePassword(passwordResetBody: PasswordResetBody, zapTraceSpan: String? = nil, apiResponseQueue: DispatchQueue? = nil, completion: @escaping (_ data: Void?,_ error: InfluxDBClient.InfluxDBError?) -> Void) {
        putMePasswordWithRequestBuilder(passwordResetBody: passwordResetBody, zapTraceSpan: zapTraceSpan).execute(apiResponseQueue ?? self.influxDB2API.apiResponseQueue) { result -> Void in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Update a password
     - PUT /me/password
     - BASIC:
       - type: http
       - name: BasicAuth
     - parameter passwordResetBody: (body) New password 
     - parameter zapTraceSpan: (header) OpenTracing span context (optional)
     - returns: RequestBuilder<Void> 
     */
    internal func putMePasswordWithRequestBuilder(passwordResetBody: PasswordResetBody, zapTraceSpan: String? = nil) -> RequestBuilder<Void> {
        let path = "/me/password"
        let URLString = influxDB2API.basePath + "/api/v2" + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: passwordResetBody)

        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Zap-Trace-Span": zapTraceSpan?.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void> = influxDB2API.requestBuilderFactory.getRequestNonDecodableBuilder(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters, influxDB2API: influxDB2API)

        return requestBuilder
    }

}
}
