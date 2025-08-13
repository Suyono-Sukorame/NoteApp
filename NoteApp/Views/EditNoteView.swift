import SwiftUI

struct EditNoteView: View {
    var note: Note
    @ObservedObject var viewModel: NoteViewModel
    @Binding var editedText: String
    @Binding var editedCategory: NoteCategory
    @Binding var isPresented: Note?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Judul")) {
                    TextField("Tulis catatan", text: $editedText)
                        .lineLimit(nil)
                }

                Section(header: Text("Kategori")) {
                    Picker("", selection: $editedCategory) {
                        ForEach(NoteCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Edit Catatan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { isPresented = nil }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        viewModel.updateNote(note: note, newTitle: editedText, newCategory: editedCategory)
                        isPresented = nil
                    }
                }
            }
        }
    }
}
