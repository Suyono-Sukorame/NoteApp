//
//  NoteViewModel.swift
//  NoteApp
//
//  Created by admin on 14/08/25.
//

import Foundation
import Combine

enum SortOption: String, CaseIterable {
    case dateCreated = "Date Created"
    case dateModified = "Date Modified"
    case title = "Title"
    case category = "Category"
}

class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet { saveNotes() }
    }
    @Published var searchText = ""
    @Published var selectedCategory: NoteCategory? = nil
    @Published var sortOption: SortOption = .dateModified
    @Published var showFavoritesOnly = false
    
    let notesKey = "notes_key"
    
    // Computed property for filtered and sorted notes
    var filteredNotes: [Note] {
        var filtered = notes
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText) ||
                note.tags.joined().localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by category
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Filter by favorites
        if showFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        // Sort notes
        switch sortOption {
        case .dateCreated:
            filtered.sort { $0.createdAt > $1.createdAt }
        case .dateModified:
            filtered.sort { $0.modifiedAt > $1.modifiedAt }
        case .title:
            filtered.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .category:
            filtered.sort { $0.category.rawValue.localizedCaseInsensitiveCompare($1.category.rawValue) == .orderedAscending }
        }
        
        return filtered
    }

    // Initializer
    init(notes: [Note] = []) {
        self.notes = notes
        loadNotes()
    }
    
    // MARK: - Note Management
    func addNote(title: String, content: String = "", category: NoteCategory, tags: [String] = []) {
        let newNote = Note(title: title, content: content, category: category, tags: tags)
        notes.append(newNote)
    }
    
    func updateNote(note: Note, newTitle: String, newContent: String, newCategory: NoteCategory, newTags: [String]) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].title = newTitle
            notes[index].content = newContent
            notes[index].category = newCategory
            notes[index].tags = newTags
            notes[index].modifiedAt = Date()
        }
    }
    
    func toggleFavorite(note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isFavorite.toggle()
            notes[index].modifiedAt = Date()
        }
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
    
    func deleteNote(note: Note) {
        notes.removeAll { $0.id == note.id }
    }
    
    // MARK: - Search and Filter
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        showFavoritesOnly = false
    }
    
    // MARK: - Statistics
    var totalNotes: Int {
        notes.count
    }
    
    var favoriteNotes: Int {
        notes.filter { $0.isFavorite }.count
    }
    
    var categoryCounts: [NoteCategory: Int] {
        Dictionary(grouping: notes, by: \.category).mapValues { $0.count }
    }

    // MARK: - Persistence
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }

    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }
}
