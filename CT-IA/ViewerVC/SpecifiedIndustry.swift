//
//  SecondViewController.swift
//  CT-IA
//
//  Created by Ethan Shin on 11/6/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage

class SpecifiedIndustryTB_Controller: ContentDisplayer
{
    
    /// Label of industry name at the top of screen
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad()
    {
        // Collection refers to the collection of alums in the specified industry
        colRef = Firestore.firestore().collection(DB.live.COL!)
        
        // Get all the data
        getPackages()
        
        //initialise storageRef
        storageRef = Storage.storage().reference()
        
        label.text = DB.live.COL!
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
        if isLoading
        {
            cell.title = "Loading"
            cell.mainImg?.image = UIImage(named: "placeholder.png")
        }
        else if !cell.imageLoading
        {
            cell.mainImg?.image = UIImage(named: "placeholder.png")
            
            let alum = allData[indexPath.row]
            
            //giving the cell a title, will be used to go to the according document when cell is selected
            cell.title = alum.name
            
            // Getting a reference of a random photo for given alumni
            let reference = storageRef!.child("Alum/\(alum.name!)/\(String((alum.imageLog?.randomElement())!))")
            
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
        DB.live.DOC = (tableView.cellForRow(at: indexPath) as! BasicCell).title
        performSegue(withIdentifier: "AlumProfile_Controller", sender: indexPath)
    }
}
