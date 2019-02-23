//
//  Image.swift
//  ReactionDiffusion
//
//  Created by Jos Kuijpers on 22/02/2019.
//  Copyright © 2019 Jos Kuijpers. All rights reserved.
//

import Foundation

class Image {
    let width: Int, height: Int
    let data: Data
    
    init(url: URL) {
        width = 0
        height = 0
        data = Data()
    }
}
