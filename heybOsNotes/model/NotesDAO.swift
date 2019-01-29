//
//  NotesDAO.swift
//  heybOsNotes
//
//  Created by mobapp02 on 28/01/2019.
//  Copyright © 2019 mobapp02. All rights reserved.
//

import Foundation
import CoreData

class NotesDao{
    
    //singelton pattern
    static let sharredInstance:NotesDao = NotesDao.init()
    // om te vermijden dat nieuwe instance wotdt gemaakt, constructor privat
    private init(){
        
    }
    //MARK: Core Data
    //opbouwen presistent container (core Data laag)
    // lazy zo lang de gebruiker geen data aanspreekt wordt deze niet in het geheugen gezet
    lazy var presistentContainer:NSPersistentContainer = {
        // verwijzing naar datamodel; waar zijn de entiteiten
        let container = NSPersistentContainer.init(name: "NotesModel")
        container.loadPersistentStores(completionHandler: {(StoreDescription, error) in
           
            
        })
        return container
    }()
    //blok ook effectief latan uitvoeren
    // zorgen voor opslaan van wijzegingen
    private func saveContext(){
        let context = presistentContainer.viewContext
        if context.hasChanges{
            // swift do catch, code uitvoeren indien iets misloopt catch blok om op te vangen
            do {
                try context.save()
            }catch{
                //hier kan je fouten opvangen
                let fout = error as NSError
                print("fout met opslaan \(fout.localizedDescription)")
                
            }
    }
}
    //MARK:basic CRUD
    // Create
    func saveNote(title:String, content:String){
        //maar notirie aan
        //zorg dat de note in de presistent container zit
        let newNote = Note(context: presistentContainer.viewContext)
        newNote.title = title
        newNote.content = content
        //savecontext, er zijn wijzigne in de container; doorgestuurt naar db
        saveContext()
    }
    //Read
    func getAllNotes()-> [Note]{
        //bouwt query op achterliggent, request algemene naam , data niet per se id DB
    
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Note")
        do{
            let notes:[Note]  = try presistentContainer.viewContext.fetch(request) as! [Note]
            return notes
            
            //querry uitvoeren; opvangen fouten nodig bv entity niet gevonden, geen toegeng, .....
        }catch{
            //iet misgelopen
            
            
        }
        //indien request niet kon uitgevoert worden, lege lijst teruggeven
        return []
    }
    func getNotesByPartOfTitle(filter:String) -> [Note]{
        // SELECT *(all) FROM Note
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Note")
        let predicate = NSPredicate.init(format: "title LIKE[cd] '*\(filter)*'")
        request.predicate = predicate
        do{
            let note:[Note] = try presistentContainer.viewContext.fetch(request) as!
            [Note]
            return note
            
        }catch{
            // iets misgelopen

        }
        return []
    }
    //update
    func updateNote(title:String, content:String , id:NSManagedObjectID){
        do{
        //query schrijven om entiteit op te vragen, check of hey bestaande was
            let note:Note = try presistentContainer.viewContext.existingObject(with: id) as! Note
            note.title = title
            note.content = content
            
        }catch{
            // als er een probleem is met updatedn verkeert id BV dan komen we in een catck block
            
        }
        saveContext()
    }
    
    //delete
    func deleteNote(note: Note){
        presistentContainer.viewContext.delete(note)
        saveContext()
        
    }
}


