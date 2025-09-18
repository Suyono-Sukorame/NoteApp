import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NoteViewModel()
    @State private var showingAddNote = false
    @State private var selectedNote: Note? = nil
    @State private var showingFilters = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search notes...", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Filter and sort bar
                HStack {
                    Button(action: {
                        showingFilters.toggle()
                    }) {
                        HStack {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                            Text("Filters")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(action: {
                                viewModel.sortOption = option
                            }) {
                                HStack {
                                    Text(option.rawValue)
                                    if viewModel.sortOption == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text(viewModel.sortOption.rawValue)
                        }
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Notes list
                if viewModel.filteredNotes.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "note.text")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text(viewModel.notes.isEmpty ? "No notes yet" : "No notes match your search")
                            .font(.title2)
                            .foregroundColor(.gray)
                        if viewModel.notes.isEmpty {
                            Text("Tap the + button to create your first note")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.filteredNotes) { note in
                            NoteRowView(note: note, viewModel: viewModel)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedNote = note
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let note = viewModel.filteredNotes[index]
                                viewModel.deleteNote(note: note)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddNote = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(viewModel: viewModel)
            }
            .sheet(item: $selectedNote) { note in
                DetailNoteView(note: note, viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Note Row View
struct NoteRowView: View {
    let note: Note
    @ObservedObject var viewModel: NoteViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Category indicator
            VStack {
                Image(systemName: note.category.icon)
                    .foregroundColor(note.category.color)
                    .font(.title3)
                Circle()
                    .fill(note.category.color)
                    .frame(width: 8, height: 8)
            }
            
            // Note content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(note.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if note.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Text(note.preview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(note.formattedModifiedDate)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // Tags preview
                    if !note.tags.isEmpty {
                        HStack(spacing: 4) {
                            ForEach(Array(note.tags.prefix(2)), id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(4)
                            }
                            if note.tags.count > 2 {
                                Text("+\(note.tags.count - 2)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            
            // Favorite button
            Button(action: {
                viewModel.toggleFavorite(note: note)
            }) {
                Image(systemName: note.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(note.isFavorite ? .red : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Filter View
struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NoteViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Filter")) {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        Text("All Categories").tag(NoteCategory?.none)
                        ForEach(NoteCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                            }.tag(NoteCategory?.some(category))
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                }
                
                Section(header: Text("Options")) {
                    Toggle("Show Favorites Only", isPresented: $viewModel.showFavoritesOnly)
                }
                
                Section(header: Text("Statistics")) {
                    HStack {
                        Text("Total Notes")
                        Spacer()
                        Text("\(viewModel.totalNotes)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Favorite Notes")
                        Spacer()
                        Text("\(viewModel.favoriteNotes)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button("Clear All Filters") {
                        viewModel.clearFilters()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

