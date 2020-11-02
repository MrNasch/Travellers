//
//  ImageEntity.swift
//  Travellers
//
//  Created by Nasch on 14/08/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation

enum ImageStatus {
    case pending, ready
}

struct ImageEntity {
    let imageId: String
    let status: ImageStatus
    let url: String?
    
    init(id: String, data: [String: Any]) {
        self.imageId = id
        
        let status = data["status"] as? String
        if let status = status?.lowercased() {
            switch status {
            case "pending":
                self.status = .pending
            case "ready":
                self.status = .ready
            default:
                self.status = .pending
            }
        } else {
            self.status = .pending
        }
        
        self.url = data["url"] as? String
    }
}
