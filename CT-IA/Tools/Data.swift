//
//  Data.swift
//  CT-IA
//
//  Created by Ethan Shin on 18/10/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import Foundation

/// A data storage format used for the children of ContentDisplayer
/// Each Package represents/contains the data for one alumnus
class Package
{
    var name:String? = nil
    var contact:String? = nil
    var loc:String? = nil
    var bio:String? = nil
    var industry:String? = nil
    var imageLog:[String]? = nil
}
