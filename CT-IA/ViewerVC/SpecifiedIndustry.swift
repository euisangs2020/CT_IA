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
        colRef = Firestore.firestore().collection(Path.liveDB.COL!)
        
        // Get all the data
        loadData()
        
        //initialise storageRef
        storageRef = Storage.storage().reference()
        
        label.text = Path.liveDB.COL!
    }
    
    
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
                        cell.mainImg.image = self.resizeImage(image!, cell.frame.width)
                    }
                }
            }
            cell.imageLoading = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        Path.liveDB.DOC = (tableView.cellForRow(at: indexPath) as! BasicCell).title
        performSegue(withIdentifier: "AlumProfile_Controller", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let receiverVC = segue.destination as! AlumProfile
    }
}
