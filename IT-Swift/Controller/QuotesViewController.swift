//
//  ViewController.swift
//  IT-Swift
//
//  Created by Chris Martin on 11/5/17.
//  Copyright © 2017 Martin Technical Solutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class QuotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Constants
    
    let Quotes_URL = "http://18.220.140.97:8080/api/quotes/"
    
    //Instance Variables
    
    var quotesArray : [Quote] = [Quote]()
    var quoteIndex : Int = 0
    
    //IB Outlets
    
    @IBOutlet weak var quotesTableView: UITableView!
    
    @IBOutlet weak var quotesSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate and Data Source
        
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        
        retrieveQuotes(url: "http://18.220.140.97:8080/api/quotes/")
        
        
    }
    
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = quotesArray[indexPath.row].Quote
        cell.detailTextLabel?.text = quotesArray[indexPath.row].Person
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quotesArray.count
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    
    func retrieveQuotes(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the quotes")
                
                let quotesJSON : JSON = JSON(response.result.value!)
                print(quotesJSON)

                for (_, object) in quotesJSON {
                    let quoteResult = quotesJSON[self.quoteIndex]["Quote"].stringValue
                    let personResult = quotesJSON[self.quoteIndex]["Person"].stringValue
                    let dateResult = quotesJSON["DateTime"].stringValue
                    
                    let quote = Quote()
                    //                    quote.DateTime = dateResult
                    quote.Person = personResult
                    quote.Quote = quoteResult
                    
                    print(quote.Person, quote.Quote)
                    
                    self.quotesArray.append(quote)
                    
                    self.quoteIndex += 1
                    print(self.quoteIndex)
                    
                }
                print(self.quotesArray[0].Quote)
                
                self.quotesTableView.reloadData()

            }
            else {
                
                print("Error \(response.result.error!)")
            }
        }
    }
        
}

