//
//  VideoData.swift
//  Media Playback App2
//
//  Created by Cristina Ciobanu on 27/03/2024.
//

import Foundation


func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Error decoding JSON: \(error)")
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
