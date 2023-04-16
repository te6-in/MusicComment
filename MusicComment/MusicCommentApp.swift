//
//  MusicCommentApp.swift
//  MusicComment
//
//  Created by 찬휘 on 10. 22..
//

import SwiftUI
import UIKit

@main
struct MusicCommentApp: App {
	init() {
		UITextView.appearance().backgroundColor = UIColor.clear
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView(coreDM: CoreDataManager())
		}
	}
}
