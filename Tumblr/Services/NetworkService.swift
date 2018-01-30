//
//  NetworkService.swift
//  Tumblr
//
//  Created by Alex Demchenko on 27/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import Moya
import RxSwift

struct Network {
    private static let provider = MoyaProvider<NetworkService>(plugins: [TrimJavascriptPlugin()])

    static func request(target: NetworkService) -> Single<Response> {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
    }
}

enum NetworkService {
    case posts(username: String)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
        case let .posts(username):
            return URL(string: "http://\(username).tumblr.com/api")!
        }
    }

    var path: String {
        switch self {
        case .posts:
            return "/read/json"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .posts:
            let parameters: [String: Any] = [
                "filter": "text"
            ]

            return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

