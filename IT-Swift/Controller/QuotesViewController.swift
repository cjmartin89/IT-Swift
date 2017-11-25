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
    
         NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    // Delegate and Data Source

        quotesTableView.delegate = self
        quotesTableView.dataSource = self

        retrieveQuotes(url: "http://18.220.140.97:8080/api/quotes/")
    }
    
    @objc func loadList(){
        //load data here
        self.retrieveQuotes(url: Quotes_URL)
        self.quotesTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            let primaryKey = self.quotesArray[indexPath.row].PK
            let DeleteQuote_URL = self.Quotes_URL + String(primaryKey)
            
            self.deleteQuote(url: DeleteQuote_URL)
            
            self.quotesArray.remove(at: Int(indexPath.row))
            let indexPath = IndexPath(item: 0, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)

            self.quotesTableView.reloadData()
        }
        
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            // share item at indexPath
        }
        
        update.backgroundColor = UIColor.blue
        
        return [delete, update]
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    
    func retrieveQuotes(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the quotes")
                
                let quotesJSON : JSON = JSON(response.result.value!)

                for (_, _) in quotesJSON {
                    let quoteResult = quotesJSON[self.quoteIndex]["Quote"].stringValue
                    let personResult = quotesJSON[self.quoteIndex]["Person"].stringValue
                    let pkResult = quotesJSON[self.quoteIndex]["pk"].intValue

                    let quote = Quote()
                    quote.Person = personResult
                    quote.Quote = quoteResult
                    quote.PK = pkResult
                    
                    self.quotesArray.append(quote)
                    self.quoteIndex += 1
                }
                self.quotesTableView.reloadData()
                
            }
            else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    func deleteQuote(url: String) {
        
        Alamofire.request(url, method: .delete)
            .responseJSON { response in
                if let error = response.result.error {
                    // got an error while deleting, need to handle it
                    print("error calling DELETE")
                    print(error)
                } else {
                    print("delete ok")
                }
        }
    }
    
        
}

