//
//  TrimJavascriptPlugin.swift
//  Tumblr
//
//  Created by Alex Demchenko on 27/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import Moya
import Result

final class TrimJavascriptPlugin: PluginType {
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case let .success(response):
            do {
                _ = try response.filterSuccessfulStatusCodes()
                let responseString = try response.mapString()

                guard let data = responseString
                    .replacingOccurrences(of: "var tumblr_api_read = ", with: "")
                    .dropLast(2)
                    .data(using: .utf8) else {
                        return result
                }

                let newResponse = Response(
                    statusCode: response.statusCode,
                    data: data,
                    request: response.request,
                    response: response.response
                )

                return Result(value: newResponse)
            } catch {
                return result
            }
        case .failure:
            return result
        }
    }
}
