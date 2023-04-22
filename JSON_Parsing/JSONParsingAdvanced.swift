//
//  JSONParsingAdvanced.swift
//  JSON_Parsing
//
//  Created by Arpan Bhowmik on 22/4/23.
//

import Foundation

struct AnyDecodable: Decodable {
    let value: Any
    
    init<T>(_ value: T?) {
        self.value = value ?? ()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else {
            self.init(())
        }
    }
}

let json = """
    {
        "foo": "Hello",
        "bar": 123
    }
""".data(using: .utf8)!

do {
    let dictionary = try JSONDecoder().decode([String: AnyDecodable].self, from: json)
   // print(dictionary)
} catch {
    print("got error while decoding \(error.localizedDescription)")
}

// MARK: - Decoding from Inherited types

class Car: Decodable {
    var make: String = ""
    var model: String = ""
}

class ElectricCar: Car {
    var range: Double = 0.0
    var hasAutoPilot: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case range
        case hasAutoPilot
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.range = try container.decode(Double.self, forKey: .range)
        self.hasAutoPilot = try container.decode(Bool.self, forKey: .hasAutoPilot)
        try super.init(from: decoder)
    }
}

let carJsonData = """
{
    "make": "Honda",
    "model": "Accord",
    "range": 400,
    "hasAutoPilot": true
}
""".data(using: .utf8)!

do {
    let electricCar = try JSONDecoder().decode(ElectricCar.self, from: carJsonData)
    //    print(electricCar.make)
    //    print(electricCar.model)
    //    print(electricCar.range)
    //    print(electricCar.hasAutoPilot)
} catch {
    print("Got error while decoding \(error.localizedDescription)")
}


// MARK: - Decoding from different types of values

let payload1 = """
{
    "coordinates": [
        {
            "latitude": 37.332,
            "longitude": -122.011
        }
    ]
}
""".data(using: .utf8)!

let payload2 = """
{
    "coordinates": [
        [37.332, -122.011]
    ]
}
""".data(using: .utf8)!

let payload3 = """
{
    "coordinates": [
        "37.332,-122.011"
    ]
}
""".data(using: .utf8)!

struct CoordinatesResponse: Decodable {
    let coordinates: [Place]
}

struct Place: Decodable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self.latitude = try container.decode(Double.self, forKey: .latitude)
            self.longitude = try container.decode(Double.self, forKey: .longitude)
        } else if var container = try? decoder.unkeyedContainer() {
            self.latitude = try container.decode(Double.self)
            self.longitude = try container.decode(Double.self)
        } else if let container = try? decoder.singleValueContainer() {
            let string = try container.decode(String.self)
            let values = string.components(separatedBy: ",")
            
            guard values.count == 2,
                  let latitude = Double(values[0]),
                  let longitude = Double(values[1]) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Decoding is not possible")
            }
            
            self.latitude = latitude
            self.longitude = longitude
        } else {
            self.latitude = 0
            self.longitude = 0
        }
    }
}

let result = try! JSONDecoder().decode(CoordinatesResponse.self, from: payload3)
print(result)

