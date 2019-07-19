//
//  RepoModel.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import RealmSwift

class RepoModel: Object, Codable {
    
    @objc dynamic var fullName: String = ""
    @objc dynamic var repoDescription: String = ""
    
}

extension RepoModel {
    enum CodingKeys: String, CodingKey {
        case fullName
        case repoDescription = "description"
    }
}
