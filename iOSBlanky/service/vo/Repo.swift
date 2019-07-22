//
//  RepoModel.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

struct Repo: Codable {
    
    let fullName: String
    let repoDescription: String?
    
}

extension Repo {
    enum CodingKeys: String, CodingKey {
        case fullName
        case repoDescription = "description"
    }
}
