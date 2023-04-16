//
//  ContentView.swift
//  MusicComment
//
//  Created by 찬휘 on 10. 22..
//

import SwiftUI

struct NoteCardView: View {
	var note: Note
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if (note.content ?? "").isEmpty == false {
				Text(note.content ?? "")
					.font(.title2)
					.bold()
					.lineSpacing(6)
					.fixedSize(horizontal: false, vertical: true)
					.foregroundColor(.white)
					.padding()
					.frame(maxWidth: .infinity, alignment: .leading)
					.shadow(color: Color("noteTextShadow"), radius: 4, x: 0, y: 2)
			}
			HStack(spacing: 12) {
				AsyncImage(url: URL(string: note.coverImageURL ?? "")) { image in
					image
						.resizable()
						.scaledToFit()
				} placeholder: {
					ProgressView()
				}
				.frame(width: 48, height: 48)
				.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
				.shadow(color: Color("noteShadow"), radius: 4, x: 0, y: 2)
				VStack(alignment: .leading) {
					Text(note.title ?? "Unavailable Title")
						.bold()
						.foregroundColor(.white)
						.lineLimit(1)
					Text(note.artist ?? "Unavailable Artist")
						.foregroundColor(.white)
						.lineLimit(1)
						.opacity(0.65)
				}
			}
			.padding(16)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(Rectangle().fill(.black).opacity(0.12))
		}
		.background(
			AsyncImage(url: URL(string: note.coverImageURL ?? "")) { image in
				image
					.resizable()
					.scaledToFill()
					.scaleEffect(1.5, anchor: .center)
					.blur(radius: 28)
					.saturation(2)
			} placeholder: { Rectangle().fill(.gray) }
				.overlay(Rectangle().fill(.black).opacity(0.2))
		)
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
	}
}

struct ContentView: View {
	let coreDM: CoreDataManager
	
	@State private var showingAddSheet = false
	
	// NOT A GOOD IDEA
	@State private var notes: [Note] = [Note]()
	
	func loadNotes() {
		notes = coreDM.getAllNotes()
	}
	
	var body: some View {
		NavigationView() {
			List {
				ForEach (notes, id: \.self) { note in
					ZStack {
						NavigationLink(destination: NoteDetailView(note: note, noteInput: note.content ?? "", coreDM: coreDM)) {
							EmptyView()
						}
						NoteCardView(note: note)
							.shadow(color: Color("noteShadow"), radius: 3, x: 0, y: 1)
					}
					.listRowSeparator(.hidden)
				}
				.onDelete(perform: { indexSet in
					indexSet.forEach { index in
						let note = notes[index]
						coreDM.deleteNote(note: note)
						loadNotes()
					}
				})
			}
			.listStyle(.plain)
			.navigationTitle(Text("Notes"))
			.toolbar {
				Button {
					self.showingAddSheet.toggle()
				} label: {
					Label("Add a new note from clipboard", systemImage: "plus.circle.fill")
				}
				.sheet(isPresented: $showingAddSheet, onDismiss: {
					loadNotes()
				}) { AddNoteView(coreDM: CoreDataManager())
				}
				.accentColor(.yellow)
			}
		}
		.onAppear(perform: {
			loadNotes()
		})
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(coreDM: CoreDataManager())
	}
}
