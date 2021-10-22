//
//  MusicCommentApp.swift
//  MusicComment
//
//  Created by 찬휘 on 10. 22..
//

import SwiftUI

@main
struct MusicCommentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
