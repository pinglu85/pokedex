//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Ping Lu on 27.10.20.
//

import UIKit

class PokemonViewController: UIViewController {
    // Connect labels from Interface Builder into Swift source, so we can manipulate the label in the view.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type1Label.text = ""
        type2Label.text = ""
        
        let url = URL(string: pokemon.url)
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
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                // Back to the main thread to update the view with data from API
                DispatchQueue.main.async {
                    // Set name label's text
                    self.nameLabel.text = self.pokemon.name
                    // Set number label's text
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    // Iterate over pokemon's types and set type labels' text
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
}
