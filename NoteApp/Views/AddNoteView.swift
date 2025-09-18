import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NoteViewModel
    @State private var title = ""
    @State private var content = ""
    @State private var selectedCategory: NoteCategory = .other
    @State private var tags = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Note Information")) {
                    TextField("Note Title", text: $title)
                    
                    VStack(alignment: .leading) {
                        Text("Content")
                            .font(.headline)
                        TextEditor(text: $content)
                            .frame(minHeight: 150)
                    }
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(NoteCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                            }.tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Tags (comma separated)")) {
                    TextField("Enter tags", text: $tags)
                }
            }
            .navigationTitle("New Note")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let tagList = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                        viewModel.addNote(
                            title: title.isEmpty ? "Untitled" : title,
                            content: content,
                            category: selectedCategory,
                            tags: tagList
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(title.isEmpty && content.isEmpty)
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        let tagList = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                        viewModel.addNote(
                            title: title.isEmpty ? "Untitled" : title,
                            content: content,
                            category: selectedCategory,
                            tags: tagList
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(title.isEmpty && content.isEmpty)
                }
                #endif
            }
        }
    }
}