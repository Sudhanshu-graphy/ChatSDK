//
//  PrefilledMessage.swift
//  Graphy
//
//  Created by Sudhanshu Dwivedi on 24/09/21.
//

import Foundation

enum PrefilledMessages: CaseIterable {
    case Hello
    case Introduce
    case Question
    
    var title: String {
        switch self {
        case .Hello:
            return AppStrings.helloEveryone
        case .Introduce:
            return AppStrings.introduceOurselves
        case .Question:
            return AppStrings.welcomeToCourse
        }
    }
}
