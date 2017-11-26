//
//  UpdateQuoteViewController.swift
//  IT-Swift
//
//  Created by Chris Martin on 11/25/17.
//  Copyright © 2017 Martin Technical Solutions. All rights reserved.
//

import UIKit
import Alamofire

class UpdateQuoteViewController: UIViewController {

    @IBOutlet weak var quoteTextField: UITextField!
    @IBOutlet weak var personTextField: UITextField!
    @IBOutlet weak var updateQuoteButton: UIButton!
    
    var quote = ""
    var person = ""
    var PK = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteTextField.text = quote
        personTextField.text = person
    }
    
    @IBAction func updateQuotePressed(_ sender: Any) {
        updateQuotes()
    }
    
    
    func updateQuotes() {
        
        let primaryKey = PK
        
        let text = quoteTextField.text
        let person = personTextField.text
        let convertedDate = retrieveDate()
        
        let quote = Quote()
        quote.Person = person!
        quote.Quote = text!
        
        let parameters = [
            "Quote": text,
            "Person": person,
            "DateTime": convertedDate
        ]
        
        let url = Quotes_URL + String(primaryKey) + "/"
        Alamofire.request(url, method:.put, parameters:parameters, encoding: JSONEncoding.default).responseString { response in
            switch response.result {
            case .success:
                print(response)
                if let i = quotesArray.index(where: {$0.PK == primaryKey}){
                    print(i)
                    quotesArray[i] = quote
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            case .failure(let error):
                print("Failed to add quote \(error)")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
