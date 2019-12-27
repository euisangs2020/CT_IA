//
//  FireUpload.swift
//  CT-IA
//
//  Created by Ethan Shin on 24/12/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class FireUpload
{
    /// The main method for uploading/saving information locally and to Firebase and Firebase Storage
    /// - Parameters:
    ///   - objects: [String----------------------------------, UIImage---------------------]
    ///   - keys:    [name, contact, loc, bio, industry, imageTitle, proPicImage]
    func mainUpload(_ objects:[Any], keys:[String])
    {
        print(objects)
        print(keys)
        for index in 0..<objects.count
        {
            var isProPic:Bool = false
            if index == keys.firstIndex(of: "proPicImage") { isProPic = true }
            
            updateField(objects[index], objects, key: keys[index], keys: keys, isProPic: isProPic)
        }
    }
    
    /// The  method for uploading/saving specific information locally and to Firebase and Firebase Storage
    /// - Parameters:
    ///   - object: The object to be saved
    ///   - objects: All the objects that have been or will be saved by the end of the mainUpload() call
    ///   - key: The key to which this object will be saved; a field descriptor of the object
    ///   - keys: All the keys to which all objects have been or will be saved by the end of the mainUpload() call
    ///   - isProPic: Boolean of whether the object is the profile picture
    private func updateField(_ object:Any, _ objects:[Any], key:String, keys:[String], isProPic:Bool)
    {
        let localData = getLocal(forKey: key)
        let name = objects.first! as! String
        let industry = objects[4] as! String
        switch localData
        {
        case nil:
            if object is UIImage
            {
                if isProPic { uni_saveProPic(name: name, object as! UIImage) }
                else { uni_saveImage(name: name, imageTitle: key, object as! UIImage, industry: industry) }
            }
            else
            {
                // If the key is "name" and the local data is nil, then the user should not exist on Firebase. Thus, a new document must be created
                
                // industry/name
                let docRef = Firestore.firestore().collection(industry).document(name)
                
                if key == name { createDoc(object, key: key, docRef: docRef) }
                else { updateDoc(object, key: key, docRef: docRef) }
                
                saveLocal(object, forKey: key)
            }
        default:
            if object is UIImage
            {
                if UIImage(data: localData as! Data) == object as? UIImage { break }
                else if isProPic { uni_saveProPic(name: name, object as! UIImage) }
                else { uni_saveImage(name: name, imageTitle: key, object as! UIImage, industry: industry) }
            }
            else
            {
                if localData as! String == object as! String { break }
                else
                {
                    // industry/name
                    let docRef = Firestore.firestore().collection(industry).document(name)
                    
                    if key == "name" { createDoc(object, key: key, docRef: docRef) }
                    else { updateDoc(object, key: key, docRef: docRef) }
                }
            }
        }
    }
    
    // MARK: Methods combining Firestore/storage and local storage
    
    private func uni_saveProPic(name:String, _ object:UIImage)
    {
        let storageRef = Storage.storage().reference().child("Alum_profile_pic/\(name).jpg")
        let data = (object as UIImage).pngData()

        uploadImage(data!, ref: storageRef)
        saveLocal(data, forKey: "proPicImage")
    }
    
    private func uni_saveImage(name:String, imageTitle:String, _ object:UIImage, industry:String)
    {
        // reference = Alum/name/imageTitle.jpg
        let storageRef = Storage.storage().reference().child("Alum/\(name)/\(imageTitle).jpg")
        
        let data = object.pngData()

        uploadImage(data!, ref: storageRef)
        
        let docRef = Firestore.firestore().collection(industry).document(name)

        docRef.updateData([
            "imageLog": FieldValue.arrayUnion(["\(imageTitle).jpg"])
        ])
        { err in
           if let err = err {
               print("Error editing document object imageLog: \(err)")
           } else {
               print("Document successfully updated")
           }
       }
    }
    
    // MARK: Local storage
    
    private func saveLocal(_ object:Any?, forKey:String)
    {
        UserDefaults.standard.set(object, forKey: forKey)
    }
    
    private func getLocal(forKey:String) -> Any?
    {
        UserDefaults.standard.object(forKey: forKey)
    }
    
    // MARK: Firebase
    
    private func createDoc(_ object:Any, key:String, docRef:DocumentReference)
    {
        docRef.setData([
            key: object
        ]) { err in
            if let err = err {
                print("Error creating document object \(key): \(err)")
            } else {
                print("Document successfully created")
            }
        }
    }
    
    private func updateDoc(_ object:Any, key:String, docRef:DocumentReference)
    {
        docRef.updateData([
            key: object
        ]) { err in
            if let err = err {
                print("Error editing document object \(key): \(err)")
                self.createDoc(object, key: key, docRef: docRef)
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    // MARK: Firebase storage
    
    private func uploadImage(_ data:Data, ref:StorageReference)
    {
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = ref.putData(data, metadata: nil)
        
        uploadTask.observe(.progress) { snapshot in
          // Upload reported progress
          let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }

        uploadTask.observe(.success) { snapshot in
          print("Image Uploaded")
        }
    }
}
