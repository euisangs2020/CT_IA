//
//  TVCells.swift
//  CT-IA
//
//  Created by Ethan Shin on 26/9/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import Foundation
import UIKit


/// The Cell used for showing images on a 1:1 square
class BasicCell:UITableViewCell
{
    @IBOutlet weak var mainImg: UIImageView!
    var imageLoading:Bool = false
    var title:String?
}

/// The Cell used for illustrating alum information on AlumProfile
class AlumCell:UITableViewCell
{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var textTwo: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
}

/* The below Cells are used for uploading images */

/// Cell for choosing image and showing image selection status
class SelectImageCell:UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectProPic: UIButton!
}

/// Cell for inserting text information (e.g. loc, name, etc)
class InsertInfoCell:UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
}

/// Cell for selecting industry via wheel scroll
class PickerCell:UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet var label: UILabel!
    @IBOutlet var picker: UIPickerView!
    
    static let defaultText = "-Select-"
    
    static let industries = [PickerCell.defaultText, "Paper & Wood", "Leather", "Transportation", "Metal", "Petroleum, Chemical, and Plastics", "Miscellaneous"]
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        picker.delegate = self
        picker.dataSource = self
    }
    
    // MARK: UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return PickerCell.industries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return PickerCell.industries[row]
    }
}

class SubmitCell:UITableViewCell
{
    @IBOutlet weak var submitB: UIButton!
}
