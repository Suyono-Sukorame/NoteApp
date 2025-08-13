//
//  ContentView.swift
//  NoteApp
//
//  Created by admin on 14/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: NoteViewModel
    @State private var newNote = ""
    @State private var selectedCategory: NoteCategory = .Personal
    @State private var editingNote: Note? = nil
    @State private var editedText = ""
    @State private var editedCategory: NoteCategory = .Personal

    init() {
        // Dummy data untuk testing
        let dummyNotes = [
            Note(title: "Belajar SwiftUI", category: .Study),
            Note(title: "Meeting dengan Tim", category: .Work),
            Note(title: "Belanja Bulanan", category: .Personal)
        ]
        _viewModel = StateObject(wrappedValue: NoteViewModel(notes: dummyNotes))
    }

    var body: some View {
        NavigationView {
            VStack {
                // Input tambah catatan
                HStack {
                    TextField("Tulis catatan baru", text: $newNote)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("", selection: $selectedCategory) {
                        ForEach(NoteCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Button(action: {
                        if !newNote.isEmpty {
                            viewModel.addNote(title: newNote, category: selectedCategory)
                            newNote = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
                .padding()

                // List catatan
                if viewModel.notes.isEmpty {
                    Spacer()
                    Text("Belum ada catatan")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.notes) { note in
                            HStack(alignment: .top) {
                                Circle()
                                    .fill(note.category.color)
                                    .frame(width: 10, height: 10)
                                Text(note.title)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                                Button(action: {
                                    editingNote = note
                                    editedText = note.title
                                    editedCategory = note.category
                                }) {
                                    Image(systemName: "pencil")
                                }
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: viewModel.deleteNote)
                    }
                }
            }
            .navigationTitle("My Notes")
            .sheet(item: $editingNote) { note in
                EditNoteView(
                    note: note,
                    viewModel: viewModel,
                    editedText: $editedText,
                    editedCategory: $editedCategory,
                    isPresented: $editingNote
                )
            }
        }
    }
}

