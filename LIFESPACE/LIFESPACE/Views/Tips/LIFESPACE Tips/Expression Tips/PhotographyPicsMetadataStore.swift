//
//  PhotographyPicsMetadataStore.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//


//
//  PhotographyPicsMetadataStore.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//

import Foundation

struct PhotographyPicsMetadataStore {

    private static var metadataURL: URL {
        let fm = FileManager.default
        let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderURL = documentsURL.appendingPathComponent("PhotographyPics")
        return folderURL.appendingPathComponent("PhotographyPicsMetadata.json")
    }

    static func load() -> [String: String] {
        let url = metadataURL
        guard let data = try? Data(contentsOf: url) else { return [:] }
        return (try? JSONDecoder().decode([String: String].self, from: data)) ?? [:]
    }

    static func upsert(filename: String, photoName: String) {
        var dict = load()
        dict[filename] = photoName
        save(dict)
    }

    static func remove(filename: String) {
        var dict = load()
        dict.removeValue(forKey: filename)
        save(dict)
    }

    private static func save(_ dict: [String: String]) {
        let url = metadataURL
        if let data = try? JSONEncoder().encode(dict) {
            try? data.write(to: url, options: .atomic)
        }
    }
}
