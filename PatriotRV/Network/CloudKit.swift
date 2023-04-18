//
//  CloudKit.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/2/23.
//

import SwiftUI
import CloudKit

extension ViewModel {
    
    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
    
    func save() async throws {
        try await saveChecklist()
        try await saveTrips()
    }    
}

//Code generated by ChatGPT to save a photo to CloudKit
//import CloudKit
//
//func saveImageToCloudKit(image: UIImage) {
//    let database = CKContainer.default().publicCloudDatabase
//    
//    // Create a new record for the image
//    let record = CKRecord(recordType: "Image")
//    
//    // Convert the image to a Data object and save it to the record
//    let imageData = image.pngData()
//    let imageAsset = CKAsset(fileURL: writeImageToDisk(data: imageData))
//    record.setValue(imageAsset, forKey: "image")
//    
//    // Save the record to the public database
//    database.save(record) { (record, error) in
//        if let error = error {
//            print("Error saving image to CloudKit: \(error.localizedDescription)")
//        } else {
//            print("Image saved to CloudKit: \(record!)")
//        }
//    }
//}
//
//// Helper function to write the image data to disk and return its URL
//func writeImageToDisk(data: Data) -> URL {
//    let directory = NSTemporaryDirectory()
//    let url = URL(fileURLWithPath: directory).appendingPathComponent(UUID().uuidString + ".png")
//    do {
//        try data.write(to: url)
//    } catch {
//        print("Error writing image data to disk: \(error.localizedDescription)")
//    }
//    return url
//}




