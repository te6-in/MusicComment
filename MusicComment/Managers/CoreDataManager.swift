//
//  CoreDataManager.swift
//  MusicComment
//
//  Created by 찬휘 on 4. 7..
//

import Foundation
import CoreData

class CoreDataManager {
	let persistentContainer: NSPersistentContainer
	
	init() {
		persistentContainer = NSPersistentContainer(name: "MusicComment")
		persistentContainer.loadPersistentStores { (description, error) in
			if let error = error {
				fatalError("Core Data Store Failed \(error.localizedDescription)")
			}
		}
	}
	
	func getAllNotes() -> [Note] {
		let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
		
		do {
			return try persistentContainer.viewContext.fetch(fetchRequest)
		} catch {
			return []
		}
	}
	
	func saveNote(content: String, title: String, artist: String, coverImageURL: String, timeCreated: Date = Date(), id: UUID = UUID()) {
		let note = Note(context: persistentContainer.viewContext)
		
		note.content = content
		note.title = title
		note.artist = artist
		note.coverImageURL = coverImageURL
		note.timeCreated = timeCreated
		note.id = id
		
		do {
			try persistentContainer.viewContext.save()
		} catch {
			print("Failed to save movie \(error)")
		}
	}
	
	func deleteNote(note: Note) {
		persistentContainer.viewContext.delete(note)
		
		do {
			try persistentContainer.viewContext.save()
		} catch {
			persistentContainer.viewContext.rollback()
			print("Failed to delete note \(error)")
		}
	}
	
	func updateNote() {
		do {
			try persistentContainer.viewContext.save()
		} catch {
			persistentContainer.viewContext.rollback()
		}
	}
}
