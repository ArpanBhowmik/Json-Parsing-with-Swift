//
//  ParsingJSONFromWebAPI.swift
//  JSON_Parsing
//
//  Created by Arpan Bhowmik on 22/4/23.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let userName: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case userName = "username"
        case email
        case address
        case phone
        case website
        case company
    }
}

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipCode: String
    let geo: Geo
    
    private enum CodingKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipCode = "zipcode"
        case geo
    }
}

struct Geo: Decodable {
    let latitude: String
    let longitude: String
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}

struct Company: Decodable {
    let name: String
    let catchPhrase: String
    let bs: String
}

let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

URLSession.shared.dataTask(with: url) { data, response, error in
    guard error == nil,
          let data else {
        print("Got error: \(String(describing: error?.localizedDescription))")
        return
    }
        
    if let users = try? JSONDecoder().decode([User].self, from: data) {
        print(users)
    } else {
        print("Got error while parsing JSON.")
    }
}.resume()

RunLoop.main.run()

