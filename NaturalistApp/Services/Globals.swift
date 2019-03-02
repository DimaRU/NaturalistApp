//
//  Globals.swift
//  NaturalistApp
//
//  Created by Dmitriy Borovikov on 28/02/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

var Globals = GlobalFactory()


class GlobalFactory {
    private var user: User? = nil
    
    var currentUser: User? {
        return self.user
    }
    
    var currentUserId: UserId {
        return self.user?.id ?? 0
    }
    
    func setCurrentUser(user: User) {
        self.user = user
    }
}
