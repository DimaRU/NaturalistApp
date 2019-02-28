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
    private var user: User?
    
    var currentUser: User {
        return self.user!
    }
    
    func setCurrentUser(user: User) {
        self.user = user
    }
}
