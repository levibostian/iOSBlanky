//
//  FileManagerExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/20/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

extension FileManager {

    class func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

}
