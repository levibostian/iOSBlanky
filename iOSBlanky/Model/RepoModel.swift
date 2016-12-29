//
//  RepoModel.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import RealmSwift
import ObjectMapper

class RepoModel: Object, Mappable {
    
    dynamic var fullName: String = ""
    dynamic var repoDescription: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        fullName <- map["full_name"]
        repoDescription <- map["description"]
    }
    
}
