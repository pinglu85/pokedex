//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ping Lu on 26.10.20.
//

import Foundation

// Codable specifies the struct is convertable to and from JSON
struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}
