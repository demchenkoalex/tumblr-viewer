//
//  PostType.swift
//  Tumblr
//
//  Created by Alex Demchenko on 27/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import Foundation

enum PostType {
    case regular(title: String?, body: String?)
    case photo(url: URL?, caption: String?)
    case link(url: URL?, text: String?)
    case other
}
