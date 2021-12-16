//
//  Persistence.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 08/12/21.
//

import Foundation
import CoreData

struct PersistenceController{
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "ApplicationDatabase")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error: \(error)")
            }
        }
    }
}


