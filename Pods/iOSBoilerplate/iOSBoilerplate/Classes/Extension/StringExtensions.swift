//
//  StringExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation

public extension String {
    
    public func get(_ index: Int) -> String {
        return self.substring(to: self.index(startIndex, offsetBy: index))
    }
    
    public func toURL() -> URL? {
        if hasPrefix("/") { // local file path.
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath = paths.first {
                if let imageFile = self.components(separatedBy: "/").last {
                    return URL(fileURLWithPath: dirPath).appendingPathComponent(imageFile)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return URL(string: self)
        }
    }
    
    public func doesFileExistInDocumentsDir() -> Bool {
        if let imageFile = self.components(separatedBy: "/").last {
            let documentsURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fooURL = documentsURL.appendingPathComponent(imageFile)
            
            return FileManager().fileExists(atPath: fooURL.path)
        } else {
            return false
        }
    }
    
    public func getDocumentsDirectoryFilePathFromRemotePath() -> String? {
        if let imageFile = self.components(separatedBy: "/").last {
            let documentsURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fooURL = documentsURL.appendingPathComponent(imageFile)
            
            return fooURL.absoluteString
        } else {
            return nil
        }
    }
    
}
