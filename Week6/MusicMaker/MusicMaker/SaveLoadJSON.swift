//
//  SaveLoadJSON
//
//  Created by jht2 on 10/25/23.
//

import Foundation

// Where is generic defined? WHat's this <T: Encodable>
//

// Write a value to file that will be stored in the documents directory as JSON
//  fileName - name of file with to store
//  val - the value to store in the file
//
func saveJSON<T: Encodable>(fileName: String, val: T) throws {
    let filePath = try documentPath(fileName: fileName);
    print("filePath: \(filePath)")
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    let jsonData = try encoder.encode(val)
    // print("Model saveAsJSON jsonData \(String(describing: jsonData))")
    
    let str = String(data: jsonData, encoding: .utf8)!
    // print("Model saveAsJSON encode str \(str)")
    
    // Terminal command 'cp' to copy output file to Downloads folder
    // The trailing period means use the same file name as the source

    try str.write(to: filePath, atomically: true, encoding: .utf8)
}

// Read a value stored as JSON from a file in the documents directory
//  fileName - name of file to read
//  returns the value converted from JSON
//
func loadJSON<T :Decodable>(_ type: T.Type, fileName: String) throws -> T {
    let filePath = try documentPath(fileName: fileName);
    let filePathExists = FileManager.default.fileExists(atPath: filePath.path)
    if !filePathExists {
        throw FileError.missing;
    }
    
    let jsonData = try String(contentsOfFile: filePath.path).data(using: .utf8)
    
    let decoder = JSONDecoder()
    return try decoder.decode(type, from: jsonData!)
}

enum FileError: Error {
    case missing
}

// Remove a file from the documents directory
//  fileName - the name of the file to remove
//
func remove(fileName: String) {
    do {
        let filePath = try documentPath(fileName: fileName);
        try FileManager.default.removeItem(at: filePath)
    } catch {
        // fatalError("Model init error \(error)")
        print("remove fileName error \(error)")
    }
}

// Return the path the a file in the user documents directory
//  fileName - name of file
//
func documentPath(fileName: String, create: Bool = false) throws -> URL {
    let directory = try FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: create)
    return directory.appendingPathComponent(fileName);
}



