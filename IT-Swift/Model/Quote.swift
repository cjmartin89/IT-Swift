//
//  Quote.swift
//  IT-Swift
//
//  Created by Chris Martin on 11/5/17.
//  Copyright © 2017 Martin Technical Solutions. All rights reserved.
//

import Foundation

let Quotes_URL = "http://18.220.140.97:8080/api/quotes/"
var quotesArray : [Quote] = [Quote]()

class Quote {
    
    var Quote : String = ""
    var Person : String = ""
    var PK : Int = 0
}

func retrieveDate() -> String {
    let date = Date()
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    
    let convertedDate = String(year) + "-" + String(month) + "-" + String(day)
    
    return convertedDate
}
