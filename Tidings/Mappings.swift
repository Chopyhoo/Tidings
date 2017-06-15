//
//  Mappings.swift
//  Tidings
//
//  Created by Alex on 12/06/2017.
//  Copyright © 2017 Alexey Sobolevski. All rights reserved.
//

import Foundation
import ObjectMapper

struct Feed : Mappable {
    var news: [News]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        news <- map["feed"]
    }
}

struct News : Mappable {
    var date: String?
    
    private var _newsLink: String?
    var newsLink: URL? {
        if let _newsLink = _newsLink {
            return URL(string: _newsLink)
        }
        return nil
    }
    
    var author: String?
    var title: String?
    
    private var _thumblink: String?
    var thumblink: URL? {
        if let _thumblink = _thumblink {
            return URL(string: _thumblink)
        }
        return nil
    }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        date <- map["date"]
        _newsLink <- map["newslink"]
        author <- map["author"]
        title <- map["title"]
        _thumblink <- map["thumblink"]
    }
}
