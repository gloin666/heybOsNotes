//
//  NoteViewController.swift
//  heybOsNotes
//
//  Created by mobapp02 on 28/01/2019.
//  Copyright © 2019 mobapp02. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConten: UITextView!
    @IBOutlet weak var dontSave: UIButton!
    var note:Note?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleEdited()
        if note != nil{
            //als note niet nul is scherm al opvullen
            tfTitle.text = note!.title
            tfConten.text = note!.content
        }
//alternatief
       // if let currentNote = note{
      //  tfTitle.text = currentNote.title
       // tfConten.text = currentNote.content
        
        //}
        
       
    }
    @IBAction func titleEdited() {
        if tfTitle.text!.count >= 3{
            dontSave.isEnabled = true
        }else{
            dontSave.isEnabled = false	
            
        }
    }
    
    @IBAction func saveButton() {
        
        if note != nil{
            NotesDao.sharredInstance.updateNote(title: tfTitle.text!, content: tfConten.text!, id: note!.objectID)
        }else{
             NotesDao.sharredInstance.saveNote(title: tfTitle.text!, content: tfConten.text!)
        }
        // opslaan achterliggent
       
        
        //terug naar vorig scherm
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func dissKeyboard(_ sender:
        UITapGestureRecognizer) {
        tfTitle.resignFirstResponder()
        tfConten.resignFirstResponder()
    }
    
    

}
