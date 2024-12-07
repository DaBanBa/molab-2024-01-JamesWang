//
//  LoadEnvFile.swift
//  Echos-of-Infinity-final
//
//  Created by James Wang on 12/2/24.
//

import Foundation

struct EnvLoader {
    static func load(from file: String = ".env") {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else {
            print("Env file not found at path: \(file)")
            return
        }
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.split(separator: "\n")
            for line in lines {
                let keyValue = line.split(separator: "=", maxSplits: 1)
                guard keyValue.count == 2 else { continue }
                let key = String(keyValue[0]).trimmingCharacters(in: .whitespaces)
                let value = String(keyValue[1]).trimmingCharacters(in: .whitespaces)
                setenv(key, value, 1)
            }
        } catch {
            print("Error loading env file: \(error)")
        }
    }
}
