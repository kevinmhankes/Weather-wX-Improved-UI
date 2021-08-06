// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityFileManagement {

    static func getFullPathUrl(_ destinationPath: String) -> URL {
        do {
            let documentDirURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return documentDirURL.appendingPathComponent(destinationPath)
        } catch {
            print("Unable to get document URL for " + destinationPath)
            return URL(string: "")!
        }
    }

    static func moveFile(_ src: String, _ target: String) {
        do {
            let documentDirUrl = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let srcUrl = documentDirUrl.appendingPathComponent(src)
            let targetUrl = documentDirUrl.appendingPathComponent(target)
            let fileManager = FileManager.default
            try fileManager.moveItem(at: srcUrl, to: targetUrl)
        } catch {
            print("Unable to move file from " + src + " to " + target)
        }
    }

    static func deleteFile(_ fileName: String) {
        do {
            let documentDirUrl = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileManager = FileManager.default
            let file = documentDirUrl.appendingPathComponent(fileName)
            try fileManager.removeItem(at: file)
        } catch {
            print("Unable to delete file: " + fileName)
        }
    }

    static func deleteAllFiles() {
        do {
            let documentDirUrl = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileManager = FileManager.default
            let filePaths = try fileManager.contentsOfDirectory(
                at: documentDirUrl,
                includingPropertiesForKeys: nil,
                options: []
            )
            for filePath in filePaths {
                try fileManager.removeItem(at: filePath)
            }
        } catch {
            print("Unable to delete all files in storage.")
        }
    }
}
