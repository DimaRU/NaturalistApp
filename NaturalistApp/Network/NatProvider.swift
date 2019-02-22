//
//  NatProvider.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 17/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Moya
import Result
import Alamofire
import PromiseKit


class NatProvider {
    typealias Response = Decodable
    typealias RequestFuture = (target: NatAPI, resolve: (Response) -> Void, reject: ErrorBlock)
    
    static let shared = NatProvider()
    
    #if DEBUG
    fileprivate static let instance = { () -> MoyaProvider<NatAPI> in
        if let value = ProcessInfo.processInfo.environment["MoyaLogger"] {
            return MoyaProvider<NatAPI>(endpointClosure: MoyaProvider.defaultEndpointMapping, plugins: [NetworkLoggerPlugin(verbose: true)])
        } else {
            return MoyaProvider<NatAPI>(endpointClosure: MoyaProvider.defaultEndpointMapping)
        }
    }()
    #else
    fileprivate static let instance = MoyaProvider<NatAPI>(endpointClosure: NatProvider.endpointClosure)
    #endif
    
    // MARK: - Public
    func request(_ target: NatAPI) -> Promise<Void> {
        let (promise, seal) = Promise<Void>.pending()
        sendRequest((target,
                     resolve: { _ in seal.fulfill(Void()) },
                     reject: seal.reject))
        return promise
    }

    func request<T: Decodable>(_ target: NatAPI) -> Promise<T> {
        let (promise, seal) = Promise<T>.pending()
        sendRequest((target,
                     resolve: { self.parseData(data: $0 as! Data, seal: seal, target: target) },
                     reject: seal.reject))
        return promise
    }

    
    private func sendRequest(_ request: RequestFuture) {
        #if DEBUG
        print("Request:", request.target)
        #endif
        NatProvider.instance.request(request.target) { (result) in
            self.handleRequest(request: request, result: result)
        }
    }
}

extension NatProvider {
    
    private func handleRequest(request: RequestFuture, result: MoyaResult) {
        switch result {
        case let .success(moyaResponse):
            switch moyaResponse.statusCode {
            case 200...299, 300...399:
                request.resolve(moyaResponse.data)
            case 401:
                print("Auth error")
                let error = NatNetworkError.authorizationNeed(message: "Auth error")
                request.reject(error)
//                AuthenticationManager.shared.attemptAuthentication(
//                    request: (request.target, { self.sendRequest(request) }, { self.handleServerError(request: request, response: moyaResponse) }))
            default:
                handleServerError(request: request, response: moyaResponse)
            }
        case .failure:
            handleNetworkFailure(request: request)
        }
    }
    
    private func handleServerError(request: RequestFuture, response moyaResponse: Moya.Response) {
        let statusCode = moyaResponse.statusCode
        let error = NatNetworkError.serverError(code: statusCode)
        request.reject(error)
    }
    
    private func handleNetworkFailure(request: RequestFuture) {
        delay(1) {
            self.sendRequest(request)
        }
    }
    
    fileprivate func parseData<T: Decodable>(data: Data, seal: Resolver<T>, target: NatAPI) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let object = try decoder.decode(T.self, from: data)
            seal.fulfill(object)
        } catch {
            print(error)
            let message = error.localizedDescription
            seal.reject(NatNetworkError.responceSyntaxError(message: message))
        }
    }
}
