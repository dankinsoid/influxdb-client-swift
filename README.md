# influxdb-client-swift

[![CircleCI](https://circleci.com/gh/influxdata/influxdb-client-swift.svg?style=svg)](https://circleci.com/gh/influxdata/influxdb-client-swift)
[![codecov](https://codecov.io/gh/influxdata/influxdb-client-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/influxdata/influxdb-client-swift)
[![Platforms](https://img.shields.io/badge/platform-macOS%20|%20iOS%20|%20watchOS%20|%20tvOS%20|%20Linux-blue.svg)](https://github.com/influxdata/influxdb-client-swift/)
[![License](https://img.shields.io/github/license/influxdata/influxdb-client-swift.svg)](https://github.com/influxdata/influxdb-client-swift/blob/master/LICENSE)
[![Documentation](https://img.shields.io/badge/docs-latest-blue)](https://influxdata.github.io/influxdb-client-swift/)
[![GitHub issues](https://img.shields.io/github/issues-raw/influxdata/influxdb-client-swift.svg)](https://github.com/influxdata/influxdb-client-swift/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/influxdata/influxdb-client-swift.svg)](https://github.com/influxdata/influxdb-client-swift/pulls)
[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://www.influxdata.com/slack)

This repository contains the reference Swift client for the InfluxDB 2.x.

- [Features](#features)
- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
- [Usage](#usage)
    - [Creating a client](#creating-a-client)
    - [Writing data](#writes)
    - [Querying data](#queries)
    - [Delete data](#delete-data)
    - [Management API](#management-api)
- [Advanced Usage](#advanced-usage)
    - [Default Tags](#default-tags)
    - [Proxy and redirects](#proxy-and-redirects)
- [Contributing](#contributing)
- [License](#license)

## Documentation

This section contains links to the client library documentation.

* [Product documentation](https://docs.influxdata.com/influxdb/latest/api-guide/client-libraries/), [Getting Started](#installation)
* [Examples](Examples/README.md#examples)
* [API Reference](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDBClient.html)
* [Changelog](CHANGELOG.md)

## Features

InfluxDB 2.x client consists of two packages

- `InfluxDBSwift`
  - Querying data using the Flux language
  - Writing data
    - batched in chunks on background
    - automatic retries on write failures
- `InfluxDBSwiftApis`
  - provides all other InfluxDB 2.x APIs for managing
    - health check
    - sources, buckets
    - tasks
    - authorizations
    - ...
  - built on top of `InfluxDBSwift`

## Supported Platforms

This package requires Swift 5 and Xcode 12+.

- iOS 14.0+
- macOS 11.0+
- tvOS 14.0+
- watchOS 7.0+
- Linux

## Installation

### Swift Package Manager

Add this line to your `Package.swift` :

~~~swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(name: "influxdb-client-swift", url: "https://github.com/influxdata/influxdb-client-swift", from: "1.7.0"),
    ],
    targets: [
        .target(name: "MyModule", dependencies: [
          .product(name: "InfluxDBSwift", package: "influxdb-client-swift"),
          // or InfluxDBSwiftApis for management API
          .product(name: "InfluxDBSwiftApis", package: "influxdb-client-swift")
        ])
    ]
)
~~~

## Usage

> Important: You should call `close()` at the end of your application to release allocated resources.

### Creating a client
Specify **url** and **token** via parameters:

```swift
let client = InfluxDBClient(url: "http://localhost:8086", token: "my-token")

...

client.close()
```

#### Client Options

| Option                     | Description                                                                   | Type               | Default |
|----------------------------|-------------------------------------------------------------------------------|--------------------|---------|
| bucket                     | Default destination bucket for writes                                         | String             | none    |
| org                        | Default organization bucket for writes                                        | String             | none    |
| precision                  | Default precision for the unix timestamps within the body line-protocol       | TimestampPrecision | ns      |
| timeoutIntervalForRequest  | The timeout interval to use when waiting for additional data.                 | TimeInterval       | 60 sec  |
| timeoutIntervalForResource | The maximum amount of time that a resource request should be allowed to take. | TimeInterval       | 5 min   |
| enableGzip                 | Enable Gzip compression for HTTP requests.                                    | Bool               | false   |
| debugging                  | Enable debugging for HTTP request/response.                                   | Bool               | false   |

##### Configure default `Bucket`, `Organization` and `Precision`

```swift
let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
        bucket: "my-bucket",
        org: "my-org",
        precision: .ns)

let client = InfluxDBClient(url: "http://localhost:8086", token: "my-token", options: options)

...

client.close()
```

#### InfluxDB 1.8 API compatibility

```swift
client = InfluxDBClient(
        url: "http://localhost:8086", 
        username: "user", 
        password: "pass",
        database: "my-db", 
        retentionPolicy: "autogen")

...

client.close()
```

### Writes

The WriteApi supports asynchronous writes into InfluxDB 2.x. 
The results of writes could be handled by `(response, error)`, `Swift.Result` or `Combine`.

The data could be written as:

1. `String` that is formatted as a InfluxDB's Line Protocol
1. [Data Point](/Sources/InfluxDBSwift/Point.swift#L11) structure
1. Tuple style mapping with keys: `measurement`, `tags`, `fields` and `time`
1. Array of above items

The following example demonstrates how to write data with Data Point structure. For further information see docs and [examples](/Examples).

```swift
import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct WriteData: AsyncParsableCommand {
  @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
  private var bucket: String

  @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
  private var org: String

  @Option(name: .shortAndLong, help: "Authentication token.")
  private var token: String

  @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
  private var url: String
}

extension WriteData {
  mutating func run() async throws {
    //
    // Initialize Client with default Bucket and Organization
    //
    let client = InfluxDBClient(
            url: url,
            token: token,
            options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

    //
    // Record defined as Data Point
    //
    let recordPoint = InfluxDBClient
            .Point("demo")
            .addTag(key: "type", value: "point")
            .addField(key: "value", value: .int(2))
    //
    // Record defined as Data Point with Timestamp
    //
    let recordPointDate = InfluxDBClient
            .Point("demo")
            .addTag(key: "type", value: "point-timestamp")
            .addField(key: "value", value: .int(2))
            .time(time: .date(Date()))

    try await client.makeWriteAPI().write(points: [recordPoint, recordPointDate])
    print("Written data:\n\n\([recordPoint, recordPointDate].map { "\t- \($0)" }.joined(separator: "\n"))")
    print("\nSuccess!")

    client.close()
  }
}
```
- sources - [WriteData/WriteData.swift](/Examples/WriteData/Sources/WriteData/WriteData.swift)

### Queries

The result retrieved by [QueryApi](/Sources/InfluxDBSwift/QueryAPI.swift#L62) could be formatted as a:

1. Lazy sequence of [FluxRecord](/Sources/InfluxDBSwift/QueryAPI.swift#L258)
1. Raw query response as a `Data`.

#### Query to FluxRecord

```swift
import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct QueryCpu: AsyncParsableCommand {
  @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
  private var bucket: String

  @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
  private var org: String

  @Option(name: .shortAndLong, help: "Authentication token.")
  private var token: String

  @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
  private var url: String
}

extension QueryCpu {
  mutating func run() async throws {
    //
    // Initialize Client with default Bucket and Organization
    //
    let client = InfluxDBClient(
            url: url,
            token: token,
            options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

    // Flux query
    let query = """
                from(bucket: "\(self.bucket)")
                    |> range(start: -10m)
                    |> filter(fn: (r) => r["_measurement"] == "cpu")
                    |> filter(fn: (r) => r["cpu"] == "cpu-total")
                    |> filter(fn: (r) => r["_field"] == "usage_user" or r["_field"] == "usage_system")
                    |> last()
                """

    print("\nQuery to execute:\n\(query)\n")

    let records = try await client.queryAPI.query(query: query)

    print("Query results:")
    try records.forEach { print(" > \($0.values["_field"]!): \($0.values["_value"]!)") }

    client.close()
  }
}
```
- sources - [QueryCpu/QueryCpu.swift](/Examples/QueryCpu/Sources/QueryCpu/QueryCpu.swift)

#### Query to Data

```swift
@main
struct QueryCpuData: AsyncParsableCommand {
  @Option(name: .shortAndLong, help: "The name or id of the bucket destination.")
  private var bucket: String

  @Option(name: .shortAndLong, help: "The name or id of the organization destination.")
  private var org: String

  @Option(name: .shortAndLong, help: "Authentication token.")
  private var token: String

  @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
  private var url: String
}

extension QueryCpuData {
  mutating func run() async throws {
    //
    // Initialize Client with default Bucket and Organization
    //
    let client = InfluxDBClient(
            url: url,
            token: token,
            options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

    // Flux query
    let query = """
                from(bucket: "\(self.bucket)")
                    |> range(start: -10m)
                    |> filter(fn: (r) => r["_measurement"] == "cpu")
                    |> filter(fn: (r) => r["cpu"] == "cpu-total")
                    |> filter(fn: (r) => r["_field"] == "usage_user" or r["_field"] == "usage_system")
                    |> last()
                """

    print("\nQuery to execute:\n\(query)\n")

    let response = try await client.queryAPI.queryRaw(query: query)

    let csv = String(decoding: response, as: UTF8.self)
    print("InfluxDB response: \(csv)")

    client.close()
  }
}
```
- sources - [QueryCpuData/QueryCpuData.swift](/Examples/QueryCpuData/Sources/QueryCpuData/QueryCpuData.swift)

#### Parameterized queries
InfluxDB Cloud supports [Parameterized Queries](https://docs.influxdata.com/influxdb/cloud/query-data/parameterized-queries/)
that let you dynamically change values in a query using the InfluxDB API. Parameterized queries make Flux queries more
reusable and can also be used to help prevent injection attacks.

InfluxDB Cloud inserts the params object into the Flux query as a Flux record named `params`. Use dot or bracket
notation to access parameters in the `params` record in your Flux query. Parameterized Flux queries support only `int`
, `float`, and `string` data types. To convert the supported data types into
other [Flux basic data types, use Flux type conversion functions](https://docs.influxdata.com/influxdb/cloud/query-data/parameterized-queries/#supported-parameter-data-types).

Parameterized query example:
> :warning: Parameterized Queries are supported only in InfluxDB Cloud, currently there is no support in InfluxDB OSS.

```swift
import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct ParameterizedQuery: AsyncParsableCommand {
  @Option(name: .shortAndLong, help: "The bucket to query. The name or id of the bucket destination.")
  private var bucket: String

  @Option(name: .shortAndLong,
          help: "The organization executing the query. Takes either the `ID` or `Name` interchangeably.")
  private var org: String

  @Option(name: .shortAndLong, help: "Authentication token.")
  private var token: String

  @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
  private var url: String
}

extension ParameterizedQuery {
  mutating func run() async throws {
    // Initialize Client with default Organization
    let client = InfluxDBClient(
            url: url,
            token: token,
            options: InfluxDBClient.InfluxDBOptions(bucket: bucket, org: org))

    for index in 1...3 {
      let point = InfluxDBClient
              .Point("demo")
              .addTag(key: "type", value: "point")
              .addField(key: "value", value: .int(index))
      try await client.makeWriteAPI().write(point: point)
    }

    // Flux query
    let query = """
                from(bucket: params.bucketParam)
                    |> range(start: -10m)
                    |> filter(fn: (r) => r["_measurement"] == params.measurement)
                """

    // Query parameters [String:String]
    let queryParams = ["bucketParam": "\(bucket)", "measurement": "demo"]

    print("\nQuery to execute:\n\n\(query)\n\n\(queryParams)")

    let records = try await client.queryAPI.query(query: query, params: queryParams)

    print("\nSuccess response...\n")

    try records.forEach { print(" > \($0.values["_field"]!): \($0.values["_value"]!)") }

    client.close()
  }
}
```
- sources - [ParameterizedQuery/ParameterizedQuery.swift](/Examples/ParameterizedQuery/Sources/ParameterizedQuery/ParameterizedQuery.swift)

### Delete data

The [DeleteAPI](https://influxdata.github.io/influxdb-client-swift/Classes/DeleteAPI.html) supports deletes 
[points](https://docs.influxdata.com/influxdb/latest/reference/glossary/#point) from an InfluxDB bucket. 
Use the [DeletePredicateRequest](https://influxdata.github.io/influxdb-client-swift/Structs/DeletePredicateRequest.html) identifies which points to delete.

```swift
import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct DeleteData: AsyncParsableCommand {
  @Option(name: .shortAndLong, help: "Specifies the bucket name to delete data from.")
  private var bucket: String

  @Option(name: .shortAndLong,
          help: "Specifies the organization name to delete data from.")
  private var org: String

  @Option(name: .shortAndLong, help: "Authentication token.")
  private var token: String

  @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
  private var url: String

  @Option(name: .shortAndLong, help: "InfluxQL-like delete predicate statement.")
  private var predicate: String
}

extension DeleteData {
  mutating func run() async throws {
    // Initialize Client with default Organization
    let client = InfluxDBClient(
            url: url,
            token: token,
            options: InfluxDBClient.InfluxDBOptions(org: self.org))

    // Create DeletePredicateRequest
    let predicateRequest = DeletePredicateRequest(
            start: Date(timeIntervalSince1970: 0),
            stop: Date(),
            predicate: predicate)

    try await client.deleteAPI.delete(predicate: predicateRequest, bucket: bucket, org: org)

    print("\nDeleted data by predicate:\n\n\t\(predicateRequest)")

    // Print date after Delete
    try await queryData(client: client)

    client.close()
  }

  private func queryData(client: InfluxDBClient) async throws {
    let query = """
                from(bucket: "\(bucket)")
                    |> range(start: 0)
                    |> filter(fn: (r) => r["_measurement"] == "server")
                    |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
                """

    let response = try await client.queryAPI.query(query: query)

    print("\nRemaining data after delete:\n")

    try response.forEach { record in
      let provider = record.values["provider"]!
      let production = record.values["production"]
      let app = record.values["app"]
      return print("\t\(provider),production=\(production!),app=\(app!)")
    }
  }
}
```
- sources - [DeleteData/DeleteData.swift](/Examples/DeleteData/Sources/DeleteData/DeleteData.swift)

### Management API

The client supports following management API:

|                                                                                                                         | API docs                                                             |
|-------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|
| [**AuthorizationsAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/AuthorizationsAPI.html) | https://docs.influxdata.com/influxdb/latest/api/#tag/Authorizations  |
| [**BucketsAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/BucketsAPI.html)               | https://docs.influxdata.com/influxdb/latest/api/#tag/Buckets         |
| [**DBRPsAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/DBRPsAPI.html)                   | https://docs.influxdata.com/influxdb/latest/api/#tag/DBRPs           |
| [**HealthAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/HealthAPI.html)                 | https://docs.influxdata.com/influxdb/latest/api/#tag/Health          |
| [**PingAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/PingAPI.html)                     | https://docs.influxdata.com/influxdb/latest/api/#tag/Ping            |
| [**LabelsAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/LabelsAPI.html)                 | https://docs.influxdata.com/influxdb/latest/api/#tag/Labels          |
| [**OrganizationsAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/OrganizationsAPI.html)   | https://docs.influxdata.com/influxdb/latest/api/#tag/Organizations   |
| [**ReadyAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/ReadyAPI.html)                   | https://docs.influxdata.com/influxdb/latest/api/#tag/Ready           |
| [**ScraperTargetsAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/ScraperTargetsAPI.html) | https://docs.influxdata.com/influxdb/latest/api/#tag/ScraperTargets  |
| [**SecretsAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/SecretsAPI.html)               | https://docs.influxdata.com/influxdb/latest/api/#tag/Secrets         |
| [**SetupAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/SetupAPI.html)                   | https://docs.influxdata.com/influxdb/latest/api/#tag/Tasks           |
| [**SourcesAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/SourcesAPI.html)               | https://docs.influxdata.com/influxdb/latest/api/#tag/Sources         |
| [**TasksAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/TasksAPI.html)                   | https://docs.influxdata.com/influxdb/latest/api/#tag/Tasks           |
| [**UsersAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/UsersAPI.html)                   | https://docs.influxdata.com/influxdb/latest/api/#tag/Users           |
| [**VariablesAPI**](https://influxdata.github.io/influxdb-client-swift/Classes/InfluxDB2API/VariablesAPI.html)           | https://docs.influxdata.com/influxdb/latest/api/#tag/Variables       |


The following example demonstrates how to use a InfluxDB 2.0 Management API to create new bucket. For further information see docs and [examples](/Examples).

```swift
import ArgumentParser
import Foundation
import InfluxDBSwift
import InfluxDBSwiftApis

@main
struct CreateNewBucket: AsyncParsableCommand {
  @Option(name: .shortAndLong, help: "New bucket name.")
  private var name: String

  @Option(name: .shortAndLong, help: "Duration bucket will retain data.")
  private var retention: Int64 = 3600

  @Option(name: .shortAndLong, help: "Specifies the organization name.")
  private var org: String

  @Option(name: .shortAndLong, help: "Authentication token.")
  private var token: String

  @Option(name: .shortAndLong, help: "HTTP address of InfluxDB.")
  private var url: String
}

extension CreateNewBucket {
  mutating func run() async throws {
    // Initialize Client and API
    let client = InfluxDBClient(url: url, token: token)
    let api = InfluxDB2API(client: client)

    let orgId = (try await api.organizationsAPI.getOrgs(org: org)!).orgs?.first?.id

    // Bucket configuration
    let request = PostBucketRequest(
            orgID: orgId!,
            name: name,
            retentionRules: [RetentionRule(type: RetentionRule.ModelType.expire, everySeconds: retention)])

    // Create Bucket
    let bucket = try await api.bucketsAPI.postBuckets(postBucketRequest: request)!

    // Create Authorization with permission to read/write created bucket
    let bucketResource = Resource(
            type: Resource.ModelType.buckets,
            id: bucket.id,
            orgID: orgId
    )

    // Authorization configuration
    let authorizationRequest = AuthorizationPostRequest(
            description: "Authorization to read/write bucket: \(name)",
            orgID: orgId!,
            permissions: [
              Permission(action: Permission.Action.read, resource: bucketResource),
              Permission(action: Permission.Action.write, resource: bucketResource)
            ])

    // Create Authorization
    let authorization = try await api.authorizationsAPI.postAuthorizations(authorizationPostRequest: authorizationRequest)!

    print("The bucket: '\(bucket.name)' is successfully created.")
    print("The following token could be use to read/write:")
    print("\t\(authorization.token!)")

    client.close()
  }
}
```
- sources - [CreateNewBucket/CreateNewBucket.swift](/Examples/CreateNewBucket/Sources/CreateNewBucket/CreateNewBucket.swift)

## Advanced Usage

### Default Tags

Sometimes is useful to store same information in every measurement e.g. `hostname`, `location`, `customer`.
The client is able to use static value or env variable as a tag value.

The expressions:
- `California Miner` - static value
- `${env.HOST_NAME}` - environment property

#### Example

```swift
client = InfluxDBClient(
        url: "http://localhost:8086",
        token: "my-token",
        options: InfluxDBClient.InfluxDBOptions(bucket: "my-bucket", org: "my-org"))

let tuple: InfluxDBClient.Point.Tuple
        = (measurement: "mem", tags: ["tag": "a"], fields: ["value": .int(3)], time: nil)

let records: [Any] = [
        InfluxDBClient.Point("mining")
                .addTag(key: "sensor_state", value: "normal")
                .addField(key: "depth", value: .int(2)),
        tuple
]

let defaultTags = InfluxDBClient.PointSettings()
        .addDefaultTag(key: "customer", value: "California Miner")
        .addDefaultTag(key: "sensor_id", value: "${env.SENSOR_ID}")

try await client.makeWriteAPI(pointSettings: defaultTags).writeRecords(records: records)
print("Successfully written default tags")
```

##### Example Output

```bash
mining,customer=California\ Miner,sensor_id=123-456-789,sensor_state=normal depth=2i
mining,customer=California\ Miner,sensor_id=123-456-789,sensor_state=normal pressure=3i
```

### Proxy and redirects

> :warning: The `connectionProxyDictionary` cannot be defined on **Linux**. You have to set `HTTPS_PROXY` or `HTTP_PROXY` system environment.

You can configure the client to tunnel requests through an HTTP proxy by `connectionProxyDictionary` option:

```swift
var connectionProxyDictionary = [AnyHashable: Any]()
connectionProxyDictionary[kCFNetworkProxiesHTTPEnable as String] = 1
connectionProxyDictionary[kCFNetworkProxiesHTTPProxy as String] = "localhost"
connectionProxyDictionary[kCFNetworkProxiesHTTPPort as String] = 3128

let options: InfluxDBClient.InfluxDBOptions = InfluxDBClient.InfluxDBOptions(
        bucket: "my-bucket",
        org: "my-org",
        precision: .ns,
        connectionProxyDictionary: connectionProxyDictionary)

client = InfluxDBClient(url: "http://localhost:8086", token: "my-token", options: options)
```
For more info see - [URLSessionConfiguration.connectionProxyDictionary](https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1411499-connectionproxydictionary), [Global Proxy Settings Constants](https://developer.apple.com/documentation/cfnetwork/global_proxy_settings_constants/).

#### Redirects

Client automatically follows HTTP redirects. You can disable redirects by an `urlSessionDelegate` configuration:

```swift
class DisableRedirect: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}

let options = InfluxDBClient.InfluxDBOptions(
        bucket: "my-bucket",
        org: "my-org",
        urlSessionDelegate: DisableRedirect())

client = InfluxDBClient(url: "http://localhost:8086", token: "my-token", options: options)
```

For more info see - [URLSessionDelegate](https://developer.apple.com/documentation/foundation/urlsessiondelegate).


## Contributing

If you would like to contribute code you can do through GitHub by forking the repository and sending a pull request into the `master` branch.

Build Requirements:

- swift 5.3 or higher

Build source and test targets:

```bash
swift build --build-tests
```

Run tests:

```bash
./Scripts/influxdb-restart.sh
swift test
```

Check code coverage:

```bash
./Scripts/influxdb-restart.sh
swift test --enable-code-coverage
```

You could also use a `docker-cli` without installing the Swift SDK:

```bash
make docker-cli
swift build
```

## License

The client is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
