//
//  ViewController.swift
//  Pokedex
//
//  Created by Ping Lu on 26.10.20.
//

import UIKit

class ViewController: UITableViewController {
    var pokemon: [Pokemon] = []
    
    // Capitalize the first letter of text
    func capitalize(text: String) -> String {
       return  text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=151")
        // Ensure url is not nil
        guard let u = url else {
            return
        }
        
        // Fetch data from API
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            // Ensure data is not nil
            guard let data = data else {
                return
            }
            
            do {
                // Parse response data
                // Function decode takes two parameters, the first one is type to decode into, the second one is data to decode.
                // We use .self to reference the type of the struct. The postfix self expression to access a type as a value. For example, SomeClass.self returns SomeClass itself, not an instance of SomeClass.
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                // Set the results from API to pokemon array
                self.pokemon = pokemonList.results
                
                // Reload table view with the data from API
                // To reload the table we have to ask the main thread (the foreground of the app) to reload the data, since our URL request is in a background thread.
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    // Set number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Grab a cell from cell pool
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        
        // Set cell's text to the name of pokemon.
        cell.textLabel?.text = capitalize(text: pokemon[indexPath.row].name)
        // Inside UITableViewCell textLabel is optional, because in some cell types it's not called textLabel. Therefore textLabel could be nil. The question mark after textLabel make sure this line will be ignored if this variable is nil.
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Ensure the segue is PokemonSegue
        if segue.identifier == "PokemonSegue" {
            // Ensure the view we are going to is a PokemonViewController
            if let destination = segue.destination as? PokemonViewController {
                // Pass the info of pokemon that user selected to the PokemonViewController
                destination.pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

