//
//  Amazon_Prime_Video_CopyApp.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 07/12/21.
//

import SwiftUI

@main
struct Amazon_Prime_Video_CopyApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TrueLoadingScreen()
                .environmentObject(MyModelClass())
        }
    }
}
