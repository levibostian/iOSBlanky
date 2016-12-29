//
//  RealmListExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import RealmSwift

extension List {
    
    // When you try to use .filter() and .map() on a realm model, it runs it on data *in the realm* database. Sometimes I want to run .filter() and .map() on data not in the realm database, but just mapped to the varible from ObjectMapper. Create Swift Array copy and use .filter() and .map() as usual.
    func arrayCopy() -> Array<T> {
        return Array(self)
    }
    
}
