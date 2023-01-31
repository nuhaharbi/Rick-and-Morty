//
//  RickAndMortyResponse.swift
//  Rick and Morty
//
//  Created by Nuha Alharbi on 30/01/2023.
//

struct RickAndMortyData : Codable {
    let info : Info
    let results : [Character]
}

struct Info : Codable {
    let next : String?
}

struct Character : Codable, Loopable{
    let name : String
    let episode : [String]
    let image: String

    let gender : String
    let species : String
    let type : String
    let status : String
    let origin : Origin
    let location : Location
}

struct Origin : Codable {
    let name : String
}

struct Location : Codable {
    let name : String
}

struct Episode : Codable {
    let episode : String
}
