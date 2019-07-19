//
//  BuildFlavor.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

enum BuildFlavor {
    case dev
    case beta
    case prod
}

extension BuildFlavor {

    var description: String {
        switch self {
        case .dev: return "dev"
        case .beta: return "beta"
        case .prod: return "prod"
        }
    }

}

extension BuildFlavor {

    static func getFromString(_ flavorString: String) -> BuildFlavor {
        switch flavorString {
        case BuildFlavor.dev.description: return .dev
        case BuildFlavor.beta.description: return .beta
        case BuildFlavor.prod.description: return .prod
        default: fatalError("You did not configure build flavors correctly")
        }
    }

}
