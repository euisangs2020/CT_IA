//
//  ContentDisplayer.swift
//  CT-IA
//
//  Created by Ethan Shin on 24/9/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage

class ContentDisplayer: UITableViewController
{
    /// The data, in Packages, that a child of ContentDisplayer will hold
    var allData:[Package] = []
    
    var colRef:CollectionReference?
    var storageRef:StorageReference?
    
    /// Boolean showing whether the images are still being fetched
    var isLoading:Bool = true
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // For when the data is not fetched yet
        if allData.isEmpty { return 1 }
        else
        {
            isLoading = false
            return allData.count
        }
    }
    
    /// Retreives documents of colRef to allData as 'Package'
    func getPackages()
    {
        colRef?.getDocuments(){
            (data, err) in
            if let err = err {
                print("oh no! \(err)")
            }
            else
            {
                for document in data!.documents { self.initData(document.data()) }
            }
            
            //Makes sure that this reloads the tableView on the main thread once the document has been retrieved
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
    }
    
    /// Initialise the retrieved document as Package
    /// - Parameter data: The document
    func initData(_ data: Dictionary<String, Any>)
    {
        let package:Package = Package()
        for key in data.keys
        {
            switch key
            {
            case "bio":
                package.bio = (data[key] as! String)
            case "contact":
                package.contact = (data[key] as! String)
            case "loc":
                package.loc = (data[key] as! String)
            case "name":
                package.name = (data[key] as! String)
            case "industry":
                package.industry = (data[key] as! String)
            case "imageLog":
                package.imageLog = (data[key] as! [String])
            default:
                continue
            }
        }
        allData.append(package)
    }
    
    /// Forcing the tableCell height to its width, accomodating for 1:1 UIImageViews
    /// - Parameters:
    ///   - tableView: self
    ///   - indexPath: The row number
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return tableView.frame.width
    }
}
