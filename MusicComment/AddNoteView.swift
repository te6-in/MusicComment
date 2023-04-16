//
//  AddNoteView.swift
//  MusicComment
//
//  Created by 찬휘 on 10. 22..
//

import SwiftUI
import SwiftSoup

class HapticManager {
	static let instance = HapticManager()
	
	func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(type)
	}
	
	func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
		let generator = UIImpactFeedbackGenerator(style: style)
		generator.impactOccurred()
	}
}

struct InputCardView: View {
	@Binding var content: String
	var title: String
	var artist: String
	let coverImageURL: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			ZStack {
				HStack {
					Text("Your note goes here!")
						.opacity(content.isEmpty ? 0.55 : 0)
					Spacer()
				}
				TextEditor(text: $content)
					.padding(EdgeInsets(top: -7, leading: -3, bottom: -11, trailing: -7))
					.shadow(color: Color("noteTextShadow"), radius: 4, x: 0, y: 2)
			}
			.font(.title2.bold())
			.lineSpacing(6)
			.foregroundColor(.white)
			.padding()
			.frame(maxWidth: .infinity, alignment: .leading)
			.fixedSize(horizontal: false, vertical: true)
			HStack(spacing: 12) {
				AsyncImage(url: URL(string: coverImageURL)) { image in
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
					Text(title)
						.bold()
						.foregroundColor(.white)
						.lineLimit(1)
					Text(artist)
						.opacity(0.65)
						.foregroundColor(.white)
						.lineLimit(1)
				}
			}
			.padding(16)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(Rectangle().fill(.black).opacity(0.12))
		}
		.background(
			AsyncImage(url: URL(string: coverImageURL)) { image in
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

struct AddNoteView: View {
	let coreDM: CoreDataManager
	
	@Environment(\.presentationMode) var presentationMode
	
	@State var note = ""
	@State var title = "Loading Title..."
	@State var artist = "Loading Artist..."
	@State var coverImageURL = ""
	
	var body: some View {
		NavigationView {
			VStack(spacing: 16) {
				ScrollView {
					InputCardView(content: $note, title: title, artist: artist, coverImageURL: coverImageURL)
						.padding()
						.shadow(color: Color("noteShadow"), radius: 3, x: 0, y: 1)
				}
				Spacer()
				Button {
					coreDM.saveNote(content: note, title: title, artist: artist, coverImageURL: coverImageURL)
					HapticManager.instance.notification(type: .success)
					self.presentationMode.wrappedValue.dismiss()
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 20, style: .continuous)
							.fill(.yellow)
							.frame(height: 52)
						HStack(spacing: 4) {
							Image(systemName: "plus.circle.fill")
								.font(.headline)
							Text("Add Note")
								.font(.headline)
								.fontWeight(.semibold)
						}
						.foregroundColor(.white)
					}
				}
				.padding()
			}
			.navigationTitle("New Note")
			.navigationBarTitleDisplayMode(.inline)
		}
		.onAppear {
			let clipboard = UIPasteboard.general.string ?? ""
			
			title = "Loading Title..."
			artist = "Loading Artist..."
			coverImageURL = ""
			
			// 오류 처리 제대로 할 것
			guard let urlAddress = URL(string: clipboard) else { return }
			let html = try! String(contentsOf: urlAddress, encoding: .utf8)
			let doc: Document = try! SwiftSoup.parse(html)
			
			let selectedRow = try! doc.select(".songs-list-row.songs-list-row--selected.selected")
			
			artist = try! selectedRow.select(".songs-list-row__by-line span").text().trimmingCharacters(in: .whitespacesAndNewlines)
			if artist.isEmpty {
				artist = try! doc.select(".product-creator").text().trimmingCharacters(in: .whitespacesAndNewlines)
			}
			
			title = try! selectedRow.select(".songs-list-row__song-name").text().trimmingCharacters(in: .whitespacesAndNewlines)
			
			coverImageURL = try! doc.select(".product-lockup__artwork-for-product picture source[type$=/jpeg]").attr("srcset").components(separatedBy: " ")[0].trimmingCharacters(in: .whitespacesAndNewlines)
		}
	}
}

struct AddNoteView_Previews: PreviewProvider {
	static var previews: some View {
//		AddNoteView(coreDM: CoreDataManager(), previewNote: )
		EmptyView()
	}
}
