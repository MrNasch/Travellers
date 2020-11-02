//
//  ProfileTests.swift
//  TravellersTests
//
//  Created by Nasch on 22/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import XCTest
import Firebase
@testable import Travellers

class ProfileTests: XCTestCase {
    
    //Given
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    var images = [ImageEntity]()
    var service = ImageService()
    
    
    func testProfil_ifExistAndConnected_ShowProfilInfos() {
        // Given
        var firstname: String?
        var lastname: String?
        var bioText: String?
        var urlImage: String?
        let docRef = db.collection("users").document("kGrazsROPvf4ERhPd7vcdSZthZP2")
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else { return }
            let dataDescription = document.data()
            let firstnameText = dataDescription!["Firstname"] as! String
            let lastnameText = dataDescription!["Lastname"] as! String
            let bioTextText = dataDescription!["Bio"] as! String
            let profileText = dataDescription!["Profil"] as! String
            firstname = firstnameText
            lastname = lastnameText
            bioText = bioTextText
            urlImage = profileText
            //Then
            XCTAssertNotNil(self.db)
            XCTAssertNotNil(self.user)
            XCTAssertNotNil(document)
            XCTAssertNil(error)
            XCTAssertEqual(firstname, "test")
            XCTAssertEqual(lastname, "destests")
            XCTAssertEqual(bioText, "Feeder")
            XCTAssertEqual(urlImage, "https://firebasestorage.googleapis.com/v0/b/travellerstest-51afb.appspot.com/o/profileImage%2FkGrazsROPvf4ERhPd7vcdSZthZP2.jpg?alt=media&token=5a116788-0b86-4270-9e38-48a3fe3154a8")
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testProfil_IfImageExist_DisplayImage() {
        // Given
        guard let userId = user?.uid else { return }
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.getAllImagesFor(userId: userId) { (images) in
            //Then
            XCTAssertNotNil(images)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testProfil_WantAddImage_AddImage() {
        // Given
        guard let userId = user?.uid else { return }
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        let data = FakeResponseData.imageData
        
        service.upload(images: [data], userId: userId) { () in
            //Then
            XCTAssertNotNil(self.images)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}



