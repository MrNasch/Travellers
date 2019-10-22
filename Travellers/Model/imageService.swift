//
//  imageService.swift
//  Travellers
//
//  Created by Nasch on 14/08/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation
import Firebase

class ImageService {
    
    static let shared = ImageService()
    
    func upload(images: [Data], userId: String, completion: @escaping () -> ()) {
        
        // upload image to DB
        let imagesCollectionRef = Firestore.firestore().collection("imagesGallery")
        let createImagesBatch = Firestore.firestore().batch()
        
        let imagesWithDocRefs = images.map { (docRef: imagesCollectionRef.document(), imageData: $0) }
        
        
        
        imagesWithDocRefs.forEach { (docRef, _) in
            let data = ["userId": userId, "dateAdded": Timestamp(date: Date()), "status": "pending"] as [String: Any]
            createImagesBatch.setData(data, forDocument: docRef)
        }
        
        createImagesBatch.commit { _ in
            completion()
        }
        
        // upload image data to storage
        let imageRef = Storage.storage().reference(withPath: "imagesGallery")
        
        imagesWithDocRefs.forEach { (docRef, imageData) in
            let imageRef = imageRef.child(docRef.documentID)
            
            imageRef.putData(imageData, metadata: nil, completion: { (meta, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                //Get new uploaded image url
                imageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    let data = ["status": "ready", "url": url?.absoluteString ?? ""] as [String: Any]
                    docRef.updateData(data)
                })
            })
        }
    }
    
    
    //display images
    func getAllImagesFor(userId: String, images: @escaping ([ImageEntity]) -> ()) {
        let imagesCollection = Firestore.firestore().collection("imagesGallery")
            .order(by: "dateAdded", descending: true)
            .whereField("userId", isEqualTo: userId)
        
        imagesCollection.addSnapshotListener { (query, error) in
            guard let query = query else {
                if let error = error {
                    print("error getting images: ", error.localizedDescription)
                }
                return
            }
            
            let imagesEntities = query.documents
                .map { ImageEntity(id: $0.documentID, data: $0.data()) }
            
            DispatchQueue.main.async {
                images(imagesEntities)
            }
        }
    }
    //V2
    //delete images
//    func delete(imageId: String, completion: @escaping () -> ()) {
//        let imageDocRef = Firestore.firestore().collection("imagesGallery").document(imageId)
//        
//        imageDocRef.delete { error in
//            if let error = error {
//                print("error: ", error.localizedDescription)
//                return
//            }
//            
//            DispatchQueue.main.async {
//                completion()
//            }
//        }
//        
//        let imageStorageRef = Storage.storage().reference(withPath: "imagesGallery").child(imageId)
//        imageStorageRef.delete()
//    }
}
