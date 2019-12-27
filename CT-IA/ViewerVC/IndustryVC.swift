//
//  FirstViewController.swift
//  CT-IA
//
//  Created by Ethan Shin on 11/6/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

/// The first ViewController; shows the selection of industries with an image each in a TableView
class IndustriesTV_Controller: ContentDisplayer
{
    override func viewDidLoad()
    {
        // Set predefined industry collection
        colRef = Firestore.firestore().collection(DB.industries.COL)
        
        // Get all the documents as Packages
        getPackages()
        
        //initialise storageRef
        storageRef = Storage.storage().reference()
    }
    
    /// Loading the table
    /// Called after the table row number is confirmed from tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    /// - Parameters:
    ///   - tableView: self
    ///   - indexPath: The row number
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //creating cell instance
        let cell:BasicCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        
        cell.mainImg.contentMode = .scaleAspectFill

        // If the image is still loading (image is getting fetched from the web)
        if isLoading == true
        {
            cell.title = "Loading"
            cell.mainImg?.image = UIImage(named: "placeholder.png")
        }
        else if !cell.imageLoading
        {
            cell.mainImg?.image = UIImage(named: "placeholder.png")
            
            //giving the cell a name, will be used to go to the according document when cell is selected
            cell.title = allData[indexPath.row].name
            let name = String(cell.title!)
            
            // Create Firebase Storage reference
            let reference = storageRef!.child("Industries/\(name).jpg")
            
            // Getting the image, rescaling
            reference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error { print(error) }
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
            cell.imageLoading = true
        }
        return cell
    }
    
    /// Action when an image is clicked
    /// Transition to the next ViewController, showing the works of alumni in the selected industry
    /// - Parameters:
    ///   - tableView: self
    ///   - indexPath: The row number
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        DB.live.COL = (tableView.cellForRow(at: indexPath) as! BasicCell).title
        performSegue(withIdentifier: "SpecifiedIndustry_Controller", sender: indexPath)
    }
}
