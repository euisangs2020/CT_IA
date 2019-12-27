//
//  Path.swift
//  CT-IA
//
//  Created by Ethan Shin on 17/10/2019.
//  Copyright © 2019 Ethan Shin. All rights reserved.
//

import Foundation

/// Values of the collection and document, if valid
class DB
{
    /// Values of the current collection and document that the user is in
    struct live
    {
        static var COL:String?
        static var DOC:String?
    }
    
    /// Fixed value of the collection for viewing the list of viable industries.
    struct industries
    {
        static let COL = "Industries"
    }
}
