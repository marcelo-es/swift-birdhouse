#!/usr/bin/swift

import Foundation

let arguments = CommandLine.arguments
if arguments.count != 3 {
    print("Usage: \(arguments[0]) <scope> <name>")
    exit(1)
}

let scope = arguments[1]
let name = arguments[2]

let url = URL(string: "http://localhost:8080/\(scope)/\(name)")!

let session = URLSession.shared
let (data, urlResponse) = try await session.data(from: url)

guard let httpResponse = urlResponse as? HTTPURLResponse else {
    print("Error: unexpected response")
    exit(1)
}

print("Status code: \(httpResponse.statusCode)")
for (key, value) in httpResponse.allHeaderFields {
    print("\(key): \(value)")
}

if data.isEmpty == false {
    let json = try JSONSerialization.jsonObject(with: data)
    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .withoutEscapingSlashes])
    guard let jsonText = String(data: jsonData, encoding: .utf8) else {
        print("Error: failed to convert JSON to text")
        exit(1)
    }
    print(jsonText)
}
