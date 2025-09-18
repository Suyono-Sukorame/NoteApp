import SwiftUI

struct DetailNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NoteViewModel
    @State var note: Note
    @State private var isEditing = false
    @State private var editedTitle: String
    @State private var editedContent: String
    @State private var editedCategory: NoteCategory
    @State private var editedTags: String
    @State private var showingDeleteAlert = false
    
    init(note: Note, viewModel: NoteViewModel) {
        self.note = note
        self.viewModel = viewModel
        _editedTitle = State(initialValue: note.title)
        _editedContent = State(initialValue: note.content)
        _editedCategory = State(initialValue: note.category)
        _editedTags = State(initialValue: note.tags.joined(separator: ", "))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with category and favorite
                    HStack {
                        HStack {
                            Image(systemName: note.category.icon)
                                .foregroundColor(note.category.color)
                            Text(note.category.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(note.category.color.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleFavorite(note: note)
                            note.isFavorite.toggle()
                        }) {
                            Image(systemName: note.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(note.isFavorite ? .red : .gray)
                                .font(.title2)
                        }
                    }
                    
                    // Title
                    if isEditing {
                        TextField("Note Title", text: $editedTitle)
                            .font(.title2)
                            .fontWeight(.bold)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(note.title)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    // Content
                    if isEditing {
                        VStack(alignment: .leading) {
                            Text("Content")
                                .font(.headline)
                            TextEditor(text: $editedContent)
                                .frame(minHeight: 200)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text("Content")
                                .font(.headline)
                            if note.content.isEmpty {
                                Text("No content")
                                    .foregroundColor(.gray)
                                    .italic()
                            } else {
                                Text(note.content)
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Category (when editing)
                    if isEditing {
                        VStack(alignment: .leading) {
                            Text("Category")
                                .font(.headline)
                            Picker("Category", selection: $editedCategory) {
                                ForEach(NoteCategory.allCases, id: \.self) { category in
                                    HStack {
                                        Image(systemName: category.icon)
                                        Text(category.rawValue)
                                    }.tag(category)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    
                    // Tags
                    if isEditing {
                        VStack(alignment: .leading) {
                            Text("Tags (comma separated)")
                                .font(.headline)
                            TextField("Enter tags", text: $editedTags)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    } else {
                        if !note.tags.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Tags")
                                    .font(.headline)
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                                    ForEach(note.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Dates
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Created:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(note.formattedCreatedDate)
                                .font(.caption)
                        }
                        HStack {
                            Text("Modified:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(note.formattedModifiedDate)
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Note Details")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if isEditing {
                            Button("Cancel") {
                                isEditing = false
                                // Reset edited values
                                editedTitle = note.title
                                editedContent = note.content
                                editedCategory = note.category
                                editedTags = note.tags.joined(separator: ", ")
                            }
                            
                            Button("Save") {
                                let tags = editedTags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                                viewModel.updateNote(
                                    note: note,
                                    newTitle: editedTitle,
                                    newContent: editedContent,
                                    newCategory: editedCategory,
                                    newTags: tags
                                )
                                
                                // Update local note
                                note.title = editedTitle
                                note.content = editedContent
                                note.category = editedCategory
                                note.tags = tags
                                note.modifiedAt = Date()
                                
                                isEditing = false
                            }
                            .fontWeight(.bold)
                        } else {
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            
                            Button("Edit") {
                                isEditing = true
                            }
                        }
                    }
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        if isEditing {
                            Button("Cancel") {
                                isEditing = false
                                // Reset edited values
                                editedTitle = note.title
                                editedContent = note.content
                                editedCategory = note.category
                                editedTags = note.tags.joined(separator: ", ")
                            }
                            
                            Button("Save") {
                                let tags = editedTags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                                viewModel.updateNote(
                                    note: note,
                                    newTitle: editedTitle,
                                    newContent: editedContent,
                                    newCategory: editedCategory,
                                    newTags: tags
                                )
                                
                                // Update local note
                                note.title = editedTitle
                                note.content = editedContent
                                note.category = editedCategory
                                note.tags = tags
                                note.modifiedAt = Date()
                                
                                isEditing = false
                            }
                            .fontWeight(.bold)
                        } else {
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            
                            Button("Edit") {
                                isEditing = true
                            }
                        }
                    }
                }
                #endif
            }
            .alert("Delete Note", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteNote(note: note)
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this note? This action cannot be undone.")
            }
        }
    }
}