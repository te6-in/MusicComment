//
//  NoteDetailView.swift
//  MusicComment
//
//  Created by 찬휘 on 4. 7..
//

import SwiftUI

struct NoteDetailView: View {
	let coreDM: CoreDataManager
	let note: Note
	@State var noteInput: String
	
	// 왜 됨? 이렇게 쓰는 게 맞음?
	init(note: Note, noteInput: String, coreDM: CoreDataManager) {
		self.note = note
		self.coreDM = coreDM
		self.noteInput = note.content ?? ""
	}
	
	var body: some View {
		NavigationView {
			VStack(spacing: 0) {
				ScrollView {
					InputCardView(content: $noteInput, title: note.title ?? "Unavailable Title", artist: note.artist ?? "Unavailable Artist", coverImageURL: note.coverImageURL ?? "")
						.shadow(color: Color("noteShadow"), radius: 3, x: 0, y: 1)
						.padding()
				}
				Spacer()
				Button {
					note.content = noteInput
					coreDM.updateNote()
					HapticManager.instance.notification(type: .success)
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 20, style: .continuous)
							.fill(.yellow)
							.frame(height: 52)
						HStack(spacing: 4) {
							Image(systemName: "pencil")
								.font(.headline)
							Text("Edit")
								.font(.headline)
								.fontWeight(.semibold)
						}
						.foregroundColor(.white)
					}
				}
				.padding()
			}
		}
		.navigationTitle(note.title ?? "Unavailable Title")
		.navigationBarTitleDisplayMode(.inline)
	}
}

//struct NoteDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//			let note = Note()
//			NoteDetailView(note: note, noteInput: note.content ?? "")
//    }
//}
