# Petitio 📫

Easy _non-blocking_ network requests for Swift packages

## Installation

You can install Petitio with SPM

1. Add or amend a `Package.swift`
2. Add this dependency `.package(url: "https://github.com/dalu93/Petitio", from: "0.1.0")`
3. Then import `Petitio` in your code and start using it 🎉

## Usage

### Basic usage

Petitio provides an easy network interface based on [vapor/http](https://github.com/vapor/http) library and fairly easy to use.

```swift
let response = try Petitio.get(
    at: "http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=3",
    parameters: [:]
).wait()
```

Or using promises provided by [SwiftNIO](https://github.com/apple/swift-nio)

```swift
try Petitio.get(
    at: "http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=3",
    parameters: [:]
).map { $0.body.data }
```

By default, Petitio 📫 provides few basic methods to achieve the most basic HTTP requests based on the HTTP methods GET, POST, PUT, PATCH, DELETE.

### GET

```swift
public static func get(
    at url: URLRepresentable,
    headers: HTTPHeaders = [:],
    parameters: [String: Any],
    using encoder: RequestEncoder = URLEncoder(),
    on worker: MultiThreadedEventLoopGroup? = nil
) throws -> EventLoopFuture<HTTPResponse> { }
```

### POST

```swift
public static func post(
    at url: URLRepresentable,
    headers: HTTPHeaders = [:],
    parameters: [String: Any],
    using encoder: RequestEncoder = BodyJSONEncoder(),
    on worker: MultiThreadedEventLoopGroup? = nil
) throws -> EventLoopFuture<HTTPResponse> { }
```

### PUT

```swift
public static func put(
    at url: URLRepresentable,
    headers: HTTPHeaders = [:],
    parameters: [String: Any],
    using encoder: RequestEncoder = BodyJSONEncoder(),
    on worker: MultiThreadedEventLoopGroup? = nil
) throws -> EventLoopFuture<HTTPResponse> { }
```

### PATCH

```swift
public static func patch(
    at url: URLRepresentable,
    headers: HTTPHeaders = [:],
    parameters: [String: Any],
    using encoder: RequestEncoder = BodyJSONEncoder(),
    on worker: MultiThreadedEventLoopGroup? = nil
) throws -> EventLoopFuture<HTTPResponse> {
```

### DELETE

```swift
public static func delete(
    at url: URLRepresentable,
    headers: HTTPHeaders = [:],
    parameters: [String: Any],
    using encoder: RequestEncoder = URLEncoder(),
    on worker: MultiThreadedEventLoopGroup? = nil
) throws -> EventLoopFuture<HTTPResponse> { }
```

### Advanced usage

#### Big data download

In case you want to download a big amount of data (ex: a video file), you can still use the `GET` request, but make sure you pass a custom worker to it as below

```swift
let worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)

Petitio
    .get(
        at: "someUrl",
        parameters: [:],
        on: worker
    )
    .flatMap { response in
        return response.body.consumeData(on: worker)
    }
```

#### Define your own encoder

Few encoders are implemented in the library, but you can create your custom one by confirming to `RequestEncoder` protocol.
Then, pass it as a parameter in the request you create

```swift
struct MyOwnEncoder: RequestEncoder {
    // implement the protocol here
}

Petitio.get(
    at: "someUrl",
    parameters: [:],
    using: MyOwnEncoder()
)
```