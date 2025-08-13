//
//  Note.swift
//  NoteApp
//
//  Created by admin on 14/08/25.
//

import Foundation
import SwiftUI

enum NoteCategory: String, CaseIterable, Codable {
    case Personal, Work, Study, Other
    
    var color: Color {
        switch self {
        case .Personal: return .green
        case .Work: return .blue
        case .Study: return .orange
        case .Other: return .gray
        }
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var category: NoteCategory
    
    init(id: UUID = UUID(), title: String, category: NoteCategory = .Other) {
        self.id = id
        self.title = title
        self.category = category
    }
}
