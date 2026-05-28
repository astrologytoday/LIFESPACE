//
//  SearchItem.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-11.
//

import Foundation

struct SearchItem: Identifiable {
    let id = UUID()
    let title: String
    let keywords: [String]
    let screen: String
}
