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

let url = URL(string: "http://localhost:8080/\(scope)/\(name)/\(version).zip")!

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

if data.isEmpty == false,
    let contentDisposition = httpResponse.allHeaderFields["Content-Disposition"] as? String,
    let filename = contentDisposition.split(separator: "\"").last
{
    try data.write(to: URL(fileURLWithPath: String(filename)))
}
