//
//  imageData.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 26/07/21.
//

import Foundation

struct FileInfo: Codable {
    let url: String?
    let type: String?
    let size: Int?
}

typealias FileData = [FileInfo]
