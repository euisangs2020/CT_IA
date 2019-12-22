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
    @IBOutlet var label: UILabel!
    @IBOutlet var selectImageB: UIButton!
}

/// Cell for inserting text information (e.g. loc, name, etc)
class InsertInfoCell:UITableViewCell
{
    @IBOutlet var label: UILabel!
    @IBOutlet var textField: UITextField!
}

class SubmitCell:UITableViewCell
{
    @IBOutlet var submitB: UIButton!
    
}
