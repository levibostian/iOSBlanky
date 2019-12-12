//
//  StringExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/11/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

extension String {
    // /Users/foo/FileName.png -> FileName.png
    func pathToFileName() -> FileName {
        return String(split(separator: "/").last!)
    }
}
