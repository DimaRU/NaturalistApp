//
//  AuthorizePromise.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 26/04/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation
import PromiseKit

public func authorizeSession() -> Promise<Void> {
    return bearerPromise()
        .then {
            NatProvider.shared.request(.apiToken(bearer: $0))
        }.then { (jwt: JWTToken) -> Promise<PagedResults<User>> in
            KeychainService.shared[.apiToken] = jwt.apiToken
            return NatProvider.shared.request(.currentUser)
        }.then { (paged: PagedResults<User>) -> Promise<Void> in
            let user = paged.results.content.first!
            Globals.setCurrentUser(user: user)
            print(user.login, user.name ?? "")
            return Promise.value(())
    }
}

private func bearerPromise() -> Promise<String> {
    if let bearer = KeychainService.shared[.bearer] {
        return Promise.value(bearer)
    } else {
        return Promise(error: PMKError.cancelled)
    }
}
