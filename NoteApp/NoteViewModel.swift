//
//  NoteViewModel.swift
//  NoteApp
//
//  Created by admin on 14/08/25.
//

import Foundation

class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet { saveNotes() }
    }

    let notesKey = "notes_key"

    // Initializer opsional untuk dummy data
    init(notes: [Note] = []) {
        self.notes = notes
        loadNotes()
    }

    func addNote(title: String, category: NoteCategory) {
        let newNote = Note(title: title, category: category)
        notes.append(newNote)
    }

    func updateNote(note: Note, newTitle: String, newCategory: NoteCategory) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].title = newTitle
            notes[index].category = newCategory
        }
    }

    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
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
