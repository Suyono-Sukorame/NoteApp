import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NoteViewModel
    @AppStorage("defaultCategory") private var defaultCategory: NoteCategory = .other
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("defaultSortOption") private var defaultSortOption: SortOption = .dateModified
    @State private var showingExportSheet = false
    @State private var showingDeleteAllAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Default Settings")) {
                    Picker("Default Category", selection: $defaultCategory) {
                        ForEach(NoteCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                            }.tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("Default Sort", selection: $defaultSortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Display")) {
                    Toggle("Show Note Preview", isOn: $showPreview)
                }
                
                Section(header: Text("Statistics")) {
                    HStack {
                        Text("Total Notes")
                        Spacer()
                        Text("\\(viewModel.totalNotes)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Favorite Notes")
                        Spacer()
                        Text("\\(viewModel.favoriteNotes)")
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes by Category")
                            .font(.headline)
                        
                        ForEach(NoteCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                                Spacer()
                                Text("\\(viewModel.categoryCounts[category] ?? 0)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section(header: Text("Data Management")) {
                    Button("Export Notes") {
                        showingExportSheet = true
                    }
                    
                    Button("Delete All Notes") {
                        showingDeleteAllAlert = true
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("H. Ahmad Ketua")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                #else
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                #endif
            }
            .actionSheet(isPresented: $showingExportSheet) {
                ActionSheet(
                    title: Text("Export Notes"),
                    message: Text("Choose export format"),
                    buttons: [
                        .default(Text("Export as Text")) {
                            exportNotesAsText()
                        },
                        .default(Text("Export as JSON")) {
                            exportNotesAsJSON()
                        },
                        .cancel()
                    ]
                )
            }
            .alert("Delete All Notes", isPresented: $showingDeleteAllAlert) {
                Button("Delete All", role: .destructive) {
                    viewModel.notes.removeAll()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete all notes? This action cannot be undone.")
            }
        }
    }
    
    private func exportNotesAsText() {
        let text = viewModel.notes.map { note in
            """
            Title: \\(note.title)
            Category: \\(note.category.rawValue)
            Created: \\(note.formattedCreatedDate)
            Modified: \\(note.formattedModifiedDate)
            Tags: \\(note.tags.joined(separator: ", "))
            
            Content:
            \\(note.content)
            
            ---
            """
        }.joined(separator: "\\n\\n")
        
        shareText(text)
    }
    
    private func exportNotesAsJSON() {
        do {
            let jsonData = try JSONEncoder().encode(viewModel.notes)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                shareText(jsonString)
            }
        } catch {
            print("Error exporting notes: \\(error)")
        }
    }
    
    private func shareText(_ text: String) {
        #if os(iOS)
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
        #else
        // For macOS, we'll just copy to clipboard
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        #endif
    }
}