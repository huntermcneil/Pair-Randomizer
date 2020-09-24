//
//  PersonViewController.swift
//  Pair Randomizer
//
//  Created by Hunter McNeil on 7/10/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var personListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchNames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomize()
        updateViews()
    }
    
    var pairs: [[Person]] = []
    
    //MARK: - Actions
    @IBAction func addPersonButtonTapped(_ sender: Any) {
        presentAlertController(person: nil)
    }
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        randomize()
    }
    
    
    //MARK: - Helper Methods
    func randomize() {
        var random: [[Person]] = []
        var new: [Person] = []
        
        for people in PersonController.shared.people.shuffled() {
            if new.count < 2 {
                new.append(people)
            } else if new.count == 2 {
                random.append(new)
                new = []
                new.append(people)
            }
        }
        if new.count > 0 {
            random.append(new)
        }
        pairs = random
        updateViews()
    }
    
    func setupViews() {
        personListTableView.delegate = self
        personListTableView.dataSource = self
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.personListTableView.reloadData()
        }
    }
    
    func fetchNames() {
        PersonController.shared.loadFromPersistenceStore()
    }
    
    func presentAlertController(person: Person?) {
        let alertController = UIAlertController(title: "Add Person", message: "Add someone new to the list", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter name here"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let nameText = alertController.textFields?[0].text, !nameText.isEmpty else {return}
            
            PersonController.shared.addName(name: nameText)
            self.updateViews()
            self.randomize()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true)
    }
}

extension PersonViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pairs.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        let person = pairs[section][row]
        
        cell.textLabel?.text = person.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let section = indexPath.section
            let personToDelete = pairs[section][row]
            
            PersonController.shared.deletePerson(person: personToDelete)
            randomize()
        }
    }
}
