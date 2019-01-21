public enum Petitio {
    public struct Configuration {
        public let timeout: TimeAmount
        public let httpVersion: HTTPVersion
    }

    public static var defaultConfiguration = Configuration(
        timeout: .minutes(1),
        httpVersion: HTTPVersion(
            major: 1,
            minor: 1
        )
    )

    public static func get(
        at url: URLRepresentable,
        headers: HTTPHeaders = [:],
        parameters: [String: Any],
        using encoder: RequestEncoder = URLEncoder(),
        on worker: MultiThreadedEventLoopGroup? = nil
    ) throws -> EventLoopFuture<HTTPResponse> {
        return try Petitio.request(
            at: url,
            method: .GET,
            headers: headers,
            parameters: parameters,
            using: encoder,
            on: worker
        )
    }

    public static func post(
        at url: URLRepresentable,
        headers: HTTPHeaders = [:],
        parameters: [String: Any],
        using encoder: RequestEncoder = BodyJSONEncoder(),
        on worker: MultiThreadedEventLoopGroup? = nil
    ) throws -> EventLoopFuture<HTTPResponse> {
        return try Petitio.request(
            at: url,
            method: .POST,
            headers: headers,
            parameters: parameters,
            using: encoder,
            on: worker
        )
    }

    public static func put(
        at url: URLRepresentable,
        headers: HTTPHeaders = [:],
        parameters: [String: Any],
        using encoder: RequestEncoder = BodyJSONEncoder(),
        on worker: MultiThreadedEventLoopGroup? = nil
    ) throws -> EventLoopFuture<HTTPResponse> {
        return try Petitio.request(
            at: url,
            method: .PUT,
            headers: headers,
            parameters: parameters,
            using: encoder,
            on: worker
        )
    }

    public static func patch(
        at url: URLRepresentable,
        headers: HTTPHeaders = [:],
        parameters: [String: Any],
        using encoder: RequestEncoder = BodyJSONEncoder(),
        on worker: MultiThreadedEventLoopGroup? = nil
    ) throws -> EventLoopFuture<HTTPResponse> {
        return try Petitio.request(
            at: url,
            method: .PATCH,
            headers: headers,
            parameters: parameters,
            using: encoder,
            on: worker
        )
    }

    public static func delete(
        at url: URLRepresentable,
        headers: HTTPHeaders = [:],
        parameters: [String: Any],
        using encoder: RequestEncoder = URLEncoder(),
        on worker: MultiThreadedEventLoopGroup? = nil
    ) throws -> EventLoopFuture<HTTPResponse> {
        return try Petitio.request(
            at: url,
            method: .DELETE,
            headers: headers,
            parameters: parameters,
            using: encoder,
            on: worker
        )
    }

    public static func sendRequestWith(
        _ descriptor: URLRequestDescriptor,
        encoder: RequestEncoder,
        client: HTTPClient,
        on worker: MultiThreadedEventLoopGroup
    ) throws -> EventLoopFuture<HTTPResponse> {
        let request = try encoder.encode(descriptor)
        let sendRequest = client.send(request)
        let closeConnection = client.close()

        return sendRequest
            .flatMap { response in
                closeConnection.and(result: response)
            }.flatMap { _, response in
                worker.eventLoop.newSucceededFuture(result: response)
            }
    }

    public static func sendRequestWith(
        _ descriptor: URLRequestDescriptor,
        encoder: RequestEncoder,
        client: EventLoopFuture<HTTPClient>,
        on worker: MultiThreadedEventLoopGroup
    ) throws -> EventLoopFuture<HTTPResponse> {
        let request = try encoder.encode(descriptor)
        return client.flatMap { client in
            client.send(request).and(result: client)
        }.flatMap { response, client in
            client.close().and(result: response)
        }.flatMap { _, response in
            worker.eventLoop.newSucceededFuture(result: response)
        }
    }
}

private extension Petitio {
    static func request(
        at url: URLRepresentable,
        method: HTTPMethod,
        headers: HTTPHeaders = [:],
        parameters: [String: Any],
        using encoder: RequestEncoder,
        on worker: MultiThreadedEventLoopGroup? = nil
    ) throws -> EventLoopFuture<HTTPResponse> {
        guard let url = url.convertToURL() else {
            throw Error.invalidURL
        }

        let worker = worker ?? MultiThreadedEventLoopGroup(numberOfThreads: 1)

        let client = try HTTPClient.connect(
            scheme: url.requireScheme(),
            hostname: url.requireHost(),
            port: url.port,
            connectTimeout: Petitio.defaultConfiguration.timeout,
            on: worker
        )

        let requestDescriptor = URLRequestDescriptor(
            url: url,
            method: method,
            headers: headers,
            parameters: parameters,
            httpVersion: Petitio.defaultConfiguration.httpVersion
        )

        return try Petitio.sendRequestWith(
            requestDescriptor,
            encoder: encoder,
            client: client,
            on: worker
        )
    }
}
