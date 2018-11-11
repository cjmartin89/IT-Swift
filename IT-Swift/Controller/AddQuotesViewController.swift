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
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quoteTextField.delegate = self
        self.personTextField.delegate = self

    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addQuoteButtonPressed(_ sender: Any) {
        addQuotes()
    }

    func addQuotes() {
        
        let text = quoteTextField.text
        let person = personTextField.text
        let convertedDate = retrieveDate()
        
        let quote = Quote()
        quote.person = person!
        quote.quote = text!
        
        let parameters = [
            "quote": text,
            "person": person,
            "DateTime": convertedDate
        ]
        
        let url = "https://calm-savannah-82295.herokuapp.com/quotes"
        Alamofire.request(url, method:.post, parameters:parameters as Parameters, encoding: JSONEncoding.default).responseString { response in
            switch response.result {
            case .success:
                print(response)
                quotesArray.append(quote)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            case .failure(let error):
                print("Failed to add quote \(error)")
            }
        }
        
         self.navigationController?.popViewController(animated: true)
    }
    
}
