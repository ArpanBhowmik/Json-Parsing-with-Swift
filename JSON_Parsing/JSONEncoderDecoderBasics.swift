//
//  JSONEncoderDecoderBasics.swift
//  JSON_Parsing
//
//  Created by Arpan Bhowmik on 22/4/23.
//

import Foundation

struct Customer: Codable {
    let firstName: String
    let lastName: String
    let age: Int
    
    //    enum CodingKeys: CodingKey {
    //        case firstName
    //        case lastName
    //        case age
    //    }
    //
    //    init(from decoder: Decoder) throws {
    //        let container = try decoder.container(keyedBy: CodingKeys.self)
    //        self.firstName = try container.decode(String.self, forKey: .firstName)
    //        self.lastName = try container.decode(String.self, forKey: .lastName)
    //        self.age = try container.decode(Int.self, forKey: .age)
    //    }
}

// JSON Decoding
let json = """
{
    "firstName": "Arpan",
    "lastName": "Bhowmik",
    "age": 27
}
""".data(using: .utf8)!

do {
    let customer = try JSONDecoder().decode(Customer.self, from: json)
    //print(customer)
} catch {
    print("got error: \(error.localizedDescription)")
}

//JSON Encoding
let customer = Customer(firstName: "Arpan", lastName: "Bhowmik", age: 27)
do {
    let encodedData = try JSONEncoder().encode(customer)
    //print(String(data: encodedData, encoding: .utf8)!)
} catch {
    print("got error while encoding: \(error.localizedDescription)")
}

// Decoding Arrays

struct Place: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let visited: Bool
}

let jsonData = """
[
{
"name": "Costa Rica",
"latitude": 28,
"longitude": 45,
"visited": true
},

{
"name": "Mexico city",
"latitude": 23,
"longitude": 45,
"visited": true
},

{
"name": "Iceland",
"latitude": 23,
"longitude": 45,
"visited": false
}
]
""".data(using: .utf8)!

do {
    let places = try JSONDecoder().decode([Place].self, from: jsonData)
    print(places)
} catch {
    print("got error in decoding data: \(error.localizedDescription)")
}


