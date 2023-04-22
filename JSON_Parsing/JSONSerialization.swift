//
//
//  JSONSerialization.swift
//
//  Created by Arpan Bhowmik on 14/4/23.
//

import Foundation

struct Customer {
    let firstName: String
    let lastName: String
    let age: Int
}

extension Customer {
    init?(dictionary: [String: Any]) {
        guard let firstName = dictionary["firstName"] as? String,
              let lastName = dictionary["lastName"] as? String,
              let age = dictionary["age"] as? Int
        else {
            return nil
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}

let json = """
[
{
    "firstName": "Arpan",
    "lastName": "Bhowmik",
    "age": 27
},

{
    "firstName": "Abc",
    "lastName": "ddfg",
    "age": 29
},

{
    "firstName": "xyz",
    "lastName": "ght",
    "age": 45
}
]
""".data(using: .utf8)

if let customerDictionaries = try? JSONSerialization.jsonObject(with: json!) as? [[String: Any]] {
    let customers = customerDictionaries.compactMap { Customer(dictionary: $0) }
    print(customers)
} else {
    print("could not parse dictionary")
}

