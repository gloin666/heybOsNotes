//
//  ViewController.swift
//  heybOsNotes
//
//  Created by mobapp02 on 28/01/2019.
//  Copyright © 2019 mobapp02. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Tableview: UITableView!
    var items:[Note] = [Note]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        items = NotesDao.sharredInstance.getAllNotes()
        Tableview.reloadData()
     
    
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNote"{
            //naar welk scherm willen we gaan
            let destintation = segue.destination as! NoteViewController
            //wat sturen we door
            let selectedCell = sender as! UITableViewCell
            let selectedIndexPath = Tableview.indexPath(for: selectedCell)!
            let selectedNote = items[selectedIndexPath.row]
            //data effectief een detaill scherm megeven
            destintation.note = selectedNote
            
        }
    }
}
//uitbreiden op viewcontroler, methoden datasource
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let noteForRow = items[indexPath.row]
            cell.textLabel?.text = noteForRow.title
            return cell
        
    }
    
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //code verwijderen note
            let toDelete = items[indexPath.row]
            NotesDao.sharredInstance.deleteNote(note: toDelete)
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    
    }
    
}

extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0{
            items = NotesDao.sharredInstance.getNotesByPartOfTitle(filter: searchText)
        }else{
            items = NotesDao.sharredInstance.getAllNotes()
    }
        Tableview.reloadData()
    }
}

