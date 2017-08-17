//
//  MacErrorNotifier.swift
//  Pods
//
//  Created by Levi Bostian on 4/3/17.
//
//

import Foundation

public protocol MacErrorNotifier {
    
    func errorEncountered(error: Error)
    
}
