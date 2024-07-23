//
//  PersistentStore.swift
//  AnyGame
//
//  Created by Alper Görler on 17.07.24.
//

import CoreData
import Foundation

class PersistentStore {
    static let shared = PersistentStore()
    
    private let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        self.container = NSPersistentContainer(name: "FavoriteGameModel") // Name des PersistentContainers _muss_ zum Namen des Data Models passen ("AnyGameModel")
        
        self.container.viewContext.automaticallyMergesChangesFromParent = true
        
        self.container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("Laden der Datenbank fehlgeschlagen: \(error.localizedDescription), UserInfo: \(error.userInfo)")
            }
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

