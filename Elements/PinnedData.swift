//
//  PinnedData.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 05/02/2024.
//

import Foundation

class PinnedData{
    static let obj = PinnedData()
    var ip : String = "1"
    
    private init(){}
    
    static func getInstance()->PinnedData{return obj}
}
