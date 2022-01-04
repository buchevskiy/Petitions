//
//  ViewController.swift
//  Project 7
//
//  Created by Андрей Бучевский on 06.09.2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
 

    override func viewDidLoad() {
        super.viewDidLoad()
        //Credit button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "filter", style: .done, target: self, action: #selector(buttonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadArray))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
       
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
    
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
 
    }
    
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    @objc func buttonTapped() {
        filteredPetitions = petitions
        tableView.reloadData()
        let alert = UIAlertController(title: "Enter text", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let filterArticle = UIAlertAction(title: "Filter", style: .default) {
            [weak self, weak alert] _ in
            guard let answer = alert?.textFields?[0].text else { return }
        
           self?.filter(answer)
        }
        alert.addAction(filterArticle)
        present(alert, animated: true, completion: nil)
    }
    //Обрабатывает ответ
     func filter(_ answer: String) {
        filteredPetitions = []
        let lowerAnswer = answer.lowercased()
        for petition in petitions {
            if petition.body.contains(lowerAnswer) {
                filteredPetitions.append(petition)
            }
        }
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
        
   
    
    @objc func showError() {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }
    
   
    @objc func reloadArray() {
        filteredPetitions = petitions
        tableView.reloadData()
    }
    

                
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

