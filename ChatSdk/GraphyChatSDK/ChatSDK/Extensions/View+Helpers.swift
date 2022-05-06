//
//  View+Helpers.swift
//  Graphy
//
//  Created by Rahul Kumar on 17/02/21.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
