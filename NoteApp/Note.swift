//
//  Note.swift
//  NoteApp
//
//  Created by admin on 14/08/25.
//

import Foundation
import SwiftUI

enum NoteCategory: String, CaseIterable, Codable {
    case personal = "Personal"
    case work = "Work"
    case study = "Study"
    case ideas = "Ideas"
    case travel = "Travel"
    case health = "Health"
    case finance = "Finance"
    case other = "Other"
    
    var color: Color {
        switch self {
        case .personal: return .green
        case .work: return .blue
        case .study: return .orange
        case .ideas: return .purple
        case .travel: return .cyan
        case .health: return .red
        case .finance: return .yellow
        case .other: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .study: return "book.fill"
        case .ideas: return "lightbulb.fill"
        case .travel: return "airplane"
        case .health: return "heart.fill"
        case .finance: return "dollarsign.circle.fill"
        case .other: return "folder.fill"
        }
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var category: NoteCategory
    var tags: [String]
    let createdAt: Date
    var modifiedAt: Date
    var isFavorite: Bool
    
    init(id: UUID = UUID(), title: String, content: String = "", category: NoteCategory = .Other, tags: [String] = [], isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.tags = tags
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.isFavorite = isFavorite
    }
    
    // Helper computed properties
    var formattedCreatedDate: String {
        DateFormatter.noteFormatter.string(from: createdAt)
    }
    
    var formattedModifiedDate: String {
        DateFormatter.noteFormatter.string(from: modifiedAt)
    }
    
    var preview: String {
        content.isEmpty ? "No content" : String(content.prefix(100))
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let noteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
