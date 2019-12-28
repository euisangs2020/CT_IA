//
//  AlumProfile.swift
//  CT-IA
//
//  Created by Ethan Shin on 26/9/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage

class AlumProfile:ContentDisplayer
{
    override func viewDidLoad()
    {
        let colRef = Firestore.firestore().collection(DB.live.COL!)
        
        // Gets the specific alumni's data
        colRef.whereField("name", isEqualTo: DB.live.DOC!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.initData(document.data())
                        
                        DispatchQueue.main.async
                        {
                            self.tableView.reloadData()
                        }
                    }
                }
        }
            
        // Initialise storageRef
        storageRef = Storage.storage().reference()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Number of images that the selected alum has, +1, accomodating for the alum profile cell at the start
        if allData.isEmpty { return 1 }
        else
        {
            isLoading = false
            return allData.first!.imageLog!.count + 1
        }
    }
    
    /// Loading the table
    /// Called after the table row number is confirmed from tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    /// - Parameters:
    ///   - tableView: self
    ///   - indexPath: The row number
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isLoading
        {
            let cell:BasicCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
            cell.mainImg.contentMode = .scaleAspectFill
            
            cell.title = "Loading"
            cell.mainImg?.image = UIImage(named: "placeholder.png")
            
            return cell
        }
        else
        {
            let alum = allData.first!
            
            // For the first UITableViewCell, use AlumCell to display basic alum info
            if indexPath.row == 0
            {
                // Creating cell instance
                let cell:AlumCell = tableView.dequeueReusableCell(withIdentifier: "AlumCell", for: indexPath) as! AlumCell
                
                cell.name.text = alum.name
                cell.textTwo.text = "\(alum.loc!), \(alum.contact!))"
                
                // Getting a reference of a random photo for given alumni
                let reference = storageRef!.child("Alum_profile_pic/\( alum.name!).jpg")
                
                // Getting the image, rescaling
                reference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if let error = error { print(error)}
                    else
                    {
                        let image = UIImage(data: data!)
                        // Asynchronous process used to make operation faster
                        DispatchQueue.main.async
                        {
                            cell.profilePic.image = ImagePicker.resizeImage(image!, cell.frame.width)
                        }
                    }
                }
                return cell
            }
            // For all subsequent rows, just creating additional pure images
            else
            {
                // Creating cell instance
                let cell:BasicCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
                
                cell.mainImg.contentMode = .scaleAspectFill
                
                // Getting a reference of a random photo for given alumni
                let reference = storageRef!.child("Alum/\( alum.name!)/\(String(alum.imageLog![indexPath.row-1]))")
                
                // Getting the image, rescaling
                reference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if let error = error { print(error)}
                    else
                    {
                        let image = UIImage(data: data!)
                        // Asynchronous process used to make operation faster
                        DispatchQueue.main.async
                        {
                            cell.mainImg.image = ImagePicker.resizeImage(image!, cell.frame.width)
                        }
                    }
                }
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 75
        }
        else
        {
            return tableView.frame.width
        }
    }
}
