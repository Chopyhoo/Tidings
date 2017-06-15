//
//  Mappings.swift
//  Tidings
//
//  Created by Alex on 12/06/2017.
//  Copyright © 2017 Alexey Sobolevski. All rights reserved.
//

import Foundation
import ObjectMapper

struct News : Mappable {
    var date: String?
    var newsLink: URL?
    var author: String?
    var title: String?
    var thumblink: URL?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        date <- map["date"]
        newsLink <- map["newsLink"]
        author <- map["author"]
        title <- map["title"]
        thumblink <- map["thumblink"]
    }
}
