//
//  UploadImage.swift
//  CT-IA
//
//  Created by Ethan Shin on 23/12/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import Foundation
import UIKit

class UploadImage: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var image:UIImage?
    var imageTitle:String?
    var proPicImage:UIImage?
    
    let labels:[String] = ["Name", "Contact", "Loc", "Bio", "Industry"]

    let imagePicker = UIImagePickerController()
    
    var fireUpload = FireUpload()
    
    /// Alert messages for different invalid inputs
    let industryMessage = "Select an industry."
    let defaultMessage = "Fill in all boxes."
    let proPicMessage = "Choose a profile picture."
    
    override func viewDidLoad()
    {
        imagePicker.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        // Since this point in code marks the state when all appropriate visible cells except SubmitCells are loaded, the text of the UITextFields or image is pre-loaded to prevent user having to enter duplicate information
        loadPrevInfo()
    }
    
    //MARK: UIImagePickerControllerDelegate Functions
    
    @IBAction func selectProPic(_ sender: UIButton)
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// If the user cancels the image choosing process
    /// - Parameter picker: Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { dismiss(animated: true, completion: nil) }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        proPicImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITableViewController Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return labels.count+2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let lastRow = tableView.numberOfRows(inSection: 0)-1

        // Loading correct cell object for given row, setting labels
        switch indexPath.row
        {
        case 0:
            let cell:SelectImageCell = tableView.dequeueReusableCell(withIdentifier: "SelectImageCell", for: indexPath) as! SelectImageCell
            cell.label.text = "Profile Pic"
            return cell
            
        case lastRow-1:
            let cell:PickerCell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerCell
            let index = indexPath.row-1
            cell.label.text = labels[index]
            cell.picker.reloadAllComponents();
            return cell
            
        case lastRow:
            let cell:SubmitCell = tableView.dequeueReusableCell(withIdentifier: "SubmitCell", for: indexPath) as! SubmitCell
            return cell

        default:
            let cell:InsertInfoCell = tableView.dequeueReusableCell(withIdentifier: "InsertInfoCell", for: indexPath) as! InsertInfoCell
            let index = indexPath.row-1
            cell.label.text = labels[index]
            return cell
        }
    }
    
    //MARK: Submission to local disk and Firebase/store via FireUpload class
    
    func showAlert(_ text:String)
    {
        let alert = UIAlertController(title: "Missing Info", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitB(_ sender: UIButton)
    {
        /// Variable to check if all fields have been entered
        var allInputted = true
        
        var objects:[Any] = []
        
        let lastRow = tableView.numberOfRows(inSection: 0)-1
        
        bigLoop: for indexPath in tableView.indexPathsForVisibleRows!
        {
            switch indexPath.row
            {
            // SelectImageCell
            case 0:
                if proPicImage == nil
                {
                    showAlert(proPicMessage)
                    allInputted = false
                    break bigLoop
                }
            // PickerCell
            case lastRow-1:
                let cell = tableView.cellForRow(at: indexPath) as! PickerCell
                let text = PickerCell.industries[cell.picker.selectedRow(inComponent: 0)]
                if text == PickerCell.defaultText
                {
                    showAlert(industryMessage)
                    allInputted = false
                    break bigLoop
                }
                else { objects.append(text) }
            // SubmitCell
            case lastRow:
                break
            // InsertInfoCell
            default:
                let infoCell = tableView.cellForRow(at: indexPath) as! InsertInfoCell
                let text = infoCell.textField.text
                if text == nil || text == ""
                {
                    showAlert(defaultMessage)
                    allInputted = false
                    break bigLoop
                }
                else { objects.append(text as Any) }
            }
        }
        
        // If all information is inputted, we can proceed to save data locally and remotely
        if allInputted
        {
            var keys:[String] = []
            
            for key in labels
            {
                keys.append(key.lowercased())
            }
            
            keys.append(imageTitle!)
            keys.append("proPicImage")
            
            objects.append(image as Any)
            objects.append(proPicImage as Any)
            
            // keys: [name, contact, loc, bio, industry, imageTitle, proPicImage]
         // objects: [String---------------------------, UIImage----------------]
            
            fireUpload.mainUpload(objects, keys: keys)
        }
    }
    
    func loadPrevInfo()
    {
        let lastRow = tableView.numberOfRows(inSection: 0)-1
        for indexPath in tableView.indexPathsForVisibleRows!
        {
            switch indexPath.row
            {
            // SelectImageCell
            case 0:
                if getData(forKey: "proPicImage") as? UIImage != nil
                {
                    let cell = tableView.cellForRow(at: indexPath) as! SelectImageCell
                    cell.selectProPic.titleLabel?.text = "Reselect"
                }
            case lastRow-1:
                let key = labels[indexPath.row-1].lowercased()
                let item = getData(forKey: key) as? String
                if item != nil
                {
                    let cell = tableView.cellForRow(at: indexPath) as! PickerCell
                    cell.picker.selectRow(PickerCell.industries.firstIndex(of: item!)!, inComponent: 0, animated: false)
                }
            // SubmitCell
            case lastRow:
                break
            // InsertInfoCell
            default:
                let key = labels[indexPath.row-1].lowercased()
                let text = getData(forKey: key)
                if text != nil
                {
                    let cell = tableView.cellForRow(at: indexPath) as! InsertInfoCell
                    cell.textField.text! = (text as! String)
                }
            }
        }
    }
    
    func getData(forKey:String) -> Any?
    {
        return UserDefaults.standard.object(forKey: forKey)
    }
    
    func setData(_ variable:Any?, forKey:String)
    {
        UserDefaults.standard.set(variable, forKey: forKey)
    }
}
