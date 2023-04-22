//
//  DecodingJSONToFlatModel.swift
//  JSON_Parsing
//
//  Created by Arpan Bhowmik on 22/4/23.
//

import Foundation

let jsonData = """
{
    "id": 1,
    "name": "Arpan Bhowmik",
    "username": "arpan",
    "email": "arpan@gmail.com",
    "address": {
        "street": "Kulas Light",
        "suite": "Apt. 556",
        "city": "Dhaka",
        "zipcode": "93737-556"
    }
}
""".data(using: .utf8)!

struct User: Decodable {
    let id: Int
    let name: String
    let userName: String
    let email: String
    
    let street: String
    let suite: String
    let city: String
    let zipCode: String
    
    private enum UserKeys: String, CodingKey {
        case id
        case name
        case userName = "username"
        case email
        case address
    }
    
    private enum AddressKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipCode = "zipcode"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.email = try container.decode(String.self, forKey: .email)
        
        let addressContainer = try container.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
        
        self.street = try addressContainer.decode(String.self, forKey: .street)
        self.suite = try addressContainer.decode(String.self, forKey: .suite)
        self.city = try addressContainer.decode(String.self, forKey: .city)
        self.zipCode = try addressContainer.decode(String.self, forKey: .zipCode)
    }
}

do {
    let user = try JSONDecoder().decode(User.self, from: jsonData)
   // print(user)
} catch {
    print("got error in decoding \(error.localizedDescription)")
}


// MARK: - Exercise decoding
let customerJsonData = """
{
    "customers": [
        {
            "FIRSTNAME": "Arpan",
            "last_name": "Bhowmik",
            "address": {
                "street": "1200 Richmond Ave",
                "city": "Houston",
                "state": "TX",
                "geo": {
                   "latitude": 34.56,
                   "longitude": 35.65
                },
                "addressType": "house"
            }
        }
    ]
}
""".data(using: .utf8)!

struct Customer: Decodable {
    let firstName: String
    let lastName: String
    let street: String
    let city: String
    let state: String
    let latitude: Double
    let longitude: Double
    let addressType: String
    
    private enum CustomerKeys: String, CodingKey {
        case firstName = "FIRSTNAME"
        case lastName = "last_name"
        case address
    }
    
    private enum AddressKeys: String, CodingKey {
        case street
        case city
        case state
        case geo
        case addressType
    }
    
    private enum GeoKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let customerContainer = try decoder.container(keyedBy: CustomerKeys.self)
        
        self.firstName = try customerContainer.decode(String.self, forKey: .firstName)
        self.lastName = try customerContainer.decode(String.self, forKey: .lastName)
        
        let addressContainer = try customerContainer.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
        
        self.street = try addressContainer.decode(String.self, forKey: .street)
        self.city = try addressContainer.decode(String.self, forKey: .city)
        self.state = try addressContainer.decode(String.self, forKey: .state)
        self.addressType = try addressContainer.decode(String.self, forKey: .addressType)
        
        let geoContainer = try addressContainer.nestedContainer(keyedBy: GeoKeys.self, forKey: .geo)
        
        self.latitude = try geoContainer.decode(Double.self, forKey: .latitude)
        self.longitude = try geoContainer.decode(Double.self, forKey: .longitude)
    }
}

struct CustomersResponse: Decodable {
    let customers: [Customer]
}

do {
    let customer = try JSONDecoder().decode(CustomersResponse.self, from: customerJsonData)
    print(customer)
} catch {
    print("got error while decoding \(error.localizedDescription)")
}

