#!/usr/bin/swift

import Foundation

let arguments = CommandLine.arguments
if arguments.count != 4 {
    print("Usage: \(arguments[0]) <scope> <name> <version>")
    exit(1)
}

let scope = arguments[1]
let name = arguments[2]
let version = arguments[3]

let url = URL(string: "http://localhost:8080/\(scope)/\(name)/\(version)/Package.swift")!

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

if data.isEmpty == false, let responseBody = String(data: data, encoding: .utf8) {
    print(responseBody)
}
