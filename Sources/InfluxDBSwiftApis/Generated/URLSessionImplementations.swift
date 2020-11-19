// URLSessionImplementations.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(MobileCoreServices)
import MobileCoreServices
#endif
import InfluxDBSwift

class URLSessionRequestBuilderFactory: RequestBuilderFactory {
    func getRequestNonDecodableBuilder<T>(method: String, URLString: String, parameters: [String:Any]?, isBody: Bool, headers: [String:String] = [:], influxDB2API: InfluxDB2API) -> RequestBuilder<T> {
        URLSessionRequestBuilder<T>(method: method, URLString: URLString, parameters: parameters, isBody: isBody, influxDB2API: influxDB2API)
    }

    func getRequestDecodableBuilder<T:Decodable>(method: String, URLString: String, parameters: [String:Any]?, isBody: Bool, headers: [String:String] = [:], influxDB2API: InfluxDB2API) -> RequestBuilder<T> {
        URLSessionDecodableRequestBuilder<T>(method: method, URLString: URLString, parameters: parameters, isBody: isBody, influxDB2API: influxDB2API)
    }
}

internal class URLSessionRequestBuilder<T>: RequestBuilder<T> {

    fileprivate var requestDelegate: URLSessionRequestBuilder<T>? = nil

    /**
     May be assigned if you want to control the authentication challenges.
     */
    public var taskDidReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?

    /**
     May be assigned if you want to do any of those things:
     - control the task completion
     - intercept and handle errors like authorization
     - retry the request.
     */
    public var taskCompletionShouldRetry: ((Data?, URLResponse?, Error?, @escaping (Bool) -> Void) -> Void)?
    
    internal override init(method: String, URLString: String, parameters: [String : Any]?, isBody: Bool, headers: [String : String] = [:], influxDB2API: InfluxDB2API) {
        super.init(method: method, URLString: URLString, parameters: parameters, isBody: isBody, headers: headers, influxDB2API: influxDB2API)
    }
    
    /**
     May be overridden by a subclass if you want to control the Content-Type
     that is given to an uploaded form part.

     Return nil to use the default behavior (inferring the Content-Type from
     the file extension).  Return the desired Content-Type otherwise.
     */
    internal func contentTypeForFormPart(fileURL: URL) -> String? {
        return nil
    }

    /**
     May be overridden by a subclass if you want to control the URLRequest
     configuration (e.g. to override the cache policy).
     */
    internal func createURLRequest(urlSession: URLSession, method: HTTPMethod, encoding: ParameterEncoding, headers: [String:String]) throws -> URLRequest {
        
        guard let url = URL(string: URLString) else {
            throw DownloadException.requestMissingURL
        }
        
        var originalRequest = URLRequest(url: url)
        
        originalRequest.httpMethod = method.rawValue
        
        headers.forEach { key, value in
            originalRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        buildHeaders().forEach { key, value in
            originalRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        let modifiedRequest = try encoding.encode(originalRequest, with: parameters)
        
        return modifiedRequest
    }

    override internal func execute(_ apiResponseQueue: DispatchQueue, _ completion: @escaping (_ result: Swift.Result<Response<T>, InfluxDBClient.InfluxDBError>) -> Void) {
        let urlSession = self.influxDB2API.getURLSession()

        let parameters: [String: Any] = self.parameters ?? [:]
        
        let fileKeys = parameters.filter { $1 is URL }
            .map { $0.0 }
        
        let encoding: ParameterEncoding
        if fileKeys.count > 0 {
            encoding = FileUploadEncoding(contentTypeForFormPart: contentTypeForFormPart(fileURL:))
        } else if isBody {
            encoding = JSONDataEncoding()
        } else {
            encoding = URLEncoding()
        }
        
        guard let xMethod = HTTPMethod(rawValue: method) else {
            fatalError("Unsuported Http method - \(method)")
        }

        let cleanupRequest = {
            self.requestDelegate = nil
        }

        do {
            let request = try createURLRequest(urlSession: urlSession, method: xMethod, encoding: encoding, headers: headers)
            
            let dataTask = urlSession.dataTask(with: request) { [weak self] data, response, error in
                
                guard let self = self else { return }
                
                if let taskCompletionShouldRetry = self.taskCompletionShouldRetry {
                    
                    taskCompletionShouldRetry(data, response, error) { [weak self] shouldRetry in
                        
                        guard let self = self else { return }
                        
                        if shouldRetry {
                            cleanupRequest()
                            self.execute(apiResponseQueue, completion)
                        } else {
                            apiResponseQueue.async {
                                cleanupRequest()
                                self.processRequestResponse(urlRequest: request, data: data, response: response, error: error, completion: completion)
                            }
                        }
                    }
                } else {
                    apiResponseQueue.async {
                        cleanupRequest()
                        self.processRequestResponse(urlRequest: request, data: data, response: response, error: error, completion: completion)
                    }
                }
            }
            
            if #available(iOS 11.0, macOS 10.13, macCatalyst 13.0, tvOS 11.0, watchOS 4.0, *) {
                onProgressReady?(dataTask.progress)
            }
            
            dataTask.resume()
            
        } catch {
            apiResponseQueue.async {
                cleanupRequest()
                completion(.failure(InfluxDBClient.InfluxDBError.error(415, nil, nil, error)))
            }
        }

    }
    
    fileprivate func processRequestResponse(urlRequest: URLRequest, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (_ result: Swift.Result<Response<T>, InfluxDBClient.InfluxDBError>) -> Void) {

        if let error = error {
            completion(.failure(InfluxDBClient.InfluxDBError.error(-1, nil, toErrorBody(data), error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(InfluxDBClient.InfluxDBError.error(-2, nil, toErrorBody(data), DecodableRequestBuilderError.nilHTTPResponse)))
            return
        }

        guard httpResponse.isStatusCodeSuccessful else {
            completion(.failure(InfluxDBClient.InfluxDBError.error(httpResponse.statusCode, httpResponse.allHeaderFields, toErrorBody(data), DecodableRequestBuilderError.unsuccessfulHTTPStatusCode)))
            return
        }

        switch T.self {
        case is String.Type:
            
            let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            
            completion(.success(Response<T>(response: httpResponse, body: body as? T)))
            
        case is URL.Type:
            do {
                
                guard error == nil else {
                    throw DownloadException.responseFailed
                }
                
                guard let data = data else {
                    throw DownloadException.responseDataMissing
                }
                
                let fileManager = FileManager.default
                let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let requestURL = try self.getURL(from: urlRequest)
                
                var requestPath = try self.getPath(from: requestURL)
                
                if let headerFileName = self.getFileName(fromContentDisposition: httpResponse.allHeaderFields["Content-Disposition"] as? String) {
                    requestPath = requestPath.appending("/\(headerFileName)")
                }
                
                let filePath = documentsDirectory.appendingPathComponent(requestPath)
                let directoryPath = filePath.deletingLastPathComponent().path
                
                try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                try data.write(to: filePath, options: .atomic)
                
                completion(.success(Response(response: httpResponse, body: filePath as? T)))
                
            } catch let requestParserError as DownloadException {
                completion(.failure(InfluxDBClient.InfluxDBError.error(400, httpResponse.allHeaderFields, toErrorBody(data), requestParserError)))
            } catch let error {
                completion(.failure(InfluxDBClient.InfluxDBError.error(400, httpResponse.allHeaderFields, toErrorBody(data), error)))
            }
            
        case is Void.Type:
            
            completion(.success(Response(response: httpResponse, body: nil)))
            
        default:
            
            completion(.success(Response(response: httpResponse, body: data as? T)))
        }

    }

    open func buildHeaders() -> [String: String] {
        var httpHeaders: [String : String] = [:]
        for (key, value) in self.headers {
            httpHeaders[key] = value
        }
        return httpHeaders
    }

    fileprivate func getFileName(fromContentDisposition contentDisposition : String?) -> String? {

        guard let contentDisposition = contentDisposition else {
            return nil
        }

        let items = contentDisposition.components(separatedBy: ";")

        var filename: String?

        for contentItem in items {

            let filenameKey = "filename="
            guard let range = contentItem.range(of: filenameKey) else {
                break
            }

            filename = contentItem
            return filename?
                .replacingCharacters(in: range, with:"")
                .replacingOccurrences(of: "\"", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return filename

    }

    fileprivate func getPath(from url : URL) throws -> String {

        guard var path = URLComponents(url: url, resolvingAgainstBaseURL: true)?.path else {
            throw DownloadException.requestMissingPath
        }

        if path.hasPrefix("/") {
            path.remove(at: path.startIndex)
        }

        return path

    }

    fileprivate func getURL(from urlRequest : URLRequest) throws -> URL {

        guard let url = urlRequest.url else {
            throw DownloadException.requestMissingURL
        }

        return url
    }

    fileprivate func toErrorBody(_ data: Data?) -> [String: Any]? {
        CodableHelper.toErrorBody(data)
    }
}

internal class URLSessionDecodableRequestBuilder<T:Decodable>: URLSessionRequestBuilder<T> {
    override fileprivate func processRequestResponse(urlRequest: URLRequest, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (_ result: Swift.Result<Response<T>, InfluxDBClient.InfluxDBError>) -> Void) {

        if let error = error {
            completion(.failure(InfluxDBClient.InfluxDBError.error(-1, nil, toErrorBody(data), error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(InfluxDBClient.InfluxDBError.error(-2, nil, toErrorBody(data), DecodableRequestBuilderError.nilHTTPResponse)))
            return
        }

        guard httpResponse.isStatusCodeSuccessful else {
            completion(.failure(InfluxDBClient.InfluxDBError.error(httpResponse.statusCode, httpResponse.allHeaderFields, toErrorBody(data), DecodableRequestBuilderError.unsuccessfulHTTPStatusCode)))
            return
        }

        switch T.self {
        case is String.Type:
            
            let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            
            completion(.success(Response<T>(response: httpResponse, body: body as? T)))
            
        case is Void.Type:
            
            completion(.success(Response(response: httpResponse, body: nil)))
            
        case is Data.Type:
            
            completion(.success(Response(response: httpResponse, body: data as? T)))
            
        default:
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(InfluxDBClient.InfluxDBError.error(httpResponse.statusCode, httpResponse.allHeaderFields, nil, DecodableRequestBuilderError.emptyDataResponse)))
                return
            }
            
            let decodeResult = CodableHelper.decode(T.self, from: data)
            
            switch decodeResult {
            case let .success(decodableObj):
                completion(.success(Response(response: httpResponse, body: decodableObj)))
            case let .failure(error):
                completion(.failure(InfluxDBClient.InfluxDBError.error(httpResponse.statusCode, httpResponse.allHeaderFields, toErrorBody(data), error)))
            }
        }
    }
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest
}

fileprivate class URLEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String : Any]?) throws -> URLRequest {
        
        var urlRequest = urlRequest
        
        guard let parameters = parameters else { return urlRequest }
        
        guard let url = urlRequest.url else {
            throw DownloadException.requestMissingURL
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = APIHelper.mapValuesToQueryItems(parameters)
            urlRequest.url = urlComponents.url
        }
        
        return urlRequest
    }
}

fileprivate class FileUploadEncoding: ParameterEncoding {

    let contentTypeForFormPart: (_ fileURL: URL) -> String?

    init(contentTypeForFormPart: @escaping (_ fileURL: URL) -> String?) {
        self.contentTypeForFormPart = contentTypeForFormPart
    }

    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {

        var urlRequest = urlRequest
        
        guard let parameters = parameters, !parameters.isEmpty else {
            return urlRequest
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
                
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        for (key, value) in parameters {
            switch value {
            case let fileURL as URL:

                urlRequest = try configureFileUploadRequest(
                    urlRequest: urlRequest,
                    boundary: boundary,
                    name: key,
                    fileURL: fileURL
                )

            case let string as String:

                if let data = string.data(using: .utf8) {
                    urlRequest = configureDataUploadRequest(
                        urlRequest: urlRequest,
                        boundary: boundary,
                        name: key,
                        data: data
                    )
                }

            case let number as NSNumber:

                if let data = number.stringValue.data(using: .utf8) {
                    urlRequest = configureDataUploadRequest(
                        urlRequest: urlRequest,
                        boundary: boundary,
                        name: key,
                        data: data
                    )
                }

            default:
                fatalError("Unprocessable value \(value) with key \(key)")
            }
        }
        
        var body = urlRequest.httpBody.orEmpty

        body.append("\r\n--\(boundary)--\r\n")

        urlRequest.httpBody = body

        return urlRequest
    }

    private func configureFileUploadRequest(urlRequest: URLRequest, boundary: String, name: String, fileURL: URL) throws -> URLRequest {

        var urlRequest = urlRequest

        var body = urlRequest.httpBody.orEmpty
        
        let fileData = try Data(contentsOf: fileURL)

        let mimetype = self.contentTypeForFormPart(fileURL) ?? mimeType(for: fileURL)

        let fileName = fileURL.lastPathComponent

        // If we already added something then we need an additional newline.
        if (body.count > 0) {
            body.append("\r\n")
        }

        // Value boundary.
        body.append("--\(boundary)\r\n")

        // Value headers.
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n")

        // Separate headers and body.
        body.append("\r\n")

        // The value data.
        body.append(fileData)
        
        urlRequest.httpBody = body

        return urlRequest
    }
    
    private func configureDataUploadRequest(urlRequest: URLRequest, boundary: String, name: String, data: Data) -> URLRequest {

        var urlRequest = urlRequest
        
        var body = urlRequest.httpBody.orEmpty

        // If we already added something then we need an additional newline.
        if (body.count > 0) {
            body.append("\r\n")
        }

        // Value boundary.
        body.append("--\(boundary)\r\n")

        // Value headers.
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")

        // Separate headers and body.
        body.append("\r\n")

        // The value data.
        body.append(data)

        urlRequest.httpBody = body

        return urlRequest

    }

    func mimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension

        #if canImport(CoreServices) || canImport(MobileCoreServices)
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        #endif

        return "application/octet-stream"
    }

}

fileprivate extension Data {
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to Data, and then add that data to the Data, this wraps it in a nice convenient little extension to Data. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

fileprivate extension Optional where Wrapped == Data {
    var orEmpty: Data {
        self ?? Data()
    }
}

extension JSONDataEncoding: ParameterEncoding {}
