//
//  AddQuotesViewController.swift
//  IT-Swift
//
//  Created by Chris Martin on 11/8/17.
//  Copyright © 2017 Martin Technical Solutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddQuotesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var quoteTextField: UITextField!
    @IBOutlet weak var personTextField: UITextField!
    @IBOutlet weak var addQuoteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quoteTextField.delegate = self
        self.personTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addQuoteButtonPressed(_ sender: Any) {
        addQuotes()
    }

    func addQuotes() {
        
        let quote = quoteTextField.text
        let person = personTextField.text
        let convertedDate = retrieveDate()
        
        let parameters = [
            "Quote": quote,
            "Person": person,
            "DateTime": convertedDate
        ]
        
        let url = "http://18.220.140.97:8080/api/quotes/create/"
        Alamofire.request(url, method:.post, parameters:parameters, encoding: JSONEncoding.default).responseString { response in
            switch response.result {
            case .success:
                print(response)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            case .failure(let error):
                print("Failed to add quote \(error)")
            }
        }

         self.navigationController?.popViewController(animated: true)
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
}
