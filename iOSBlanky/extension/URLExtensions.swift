//
//  URLExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/23/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

extension URL {

    // Send a URL string and it returns value of query param.
    // Example: http://example.com?test1=foo&test2=bar => param: test1 and get back 'foo'
    func getQueryParamValue(_ param: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }

        return url.queryItems?.first(where: { $0.name == param })?.value
    }

}
