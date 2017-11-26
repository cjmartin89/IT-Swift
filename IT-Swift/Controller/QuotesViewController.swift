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

class QuotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
   var filteredQuotes = [Quote]()
   var isSearching = false
    

    //Instance Variables
    
    var quoteIndex : Int = 0
    var updateQuoteText = ""
    var updatePersonText = ""
    var updatePK = 0
    
    //IB Outlets
    
    @IBOutlet weak var quotesTableView: UITableView!
    @IBOutlet weak var quotesSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
         NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    // Delegate and Data Source

        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        quotesSearchBar.delegate = self
        quotesSearchBar.returnKeyType = UIReturnKeyType.done

        retrieveQuotes(url: "http://18.220.140.97:8080/api/quotes/")

        self.quotesTableView.addSubview(self.refreshControl)
        
        quotesTableView.tableFooterView = UIView()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateQuoteSegue" {
            
            let updateQuoteViewController = segue.destination as! UpdateQuoteViewController
            updateQuoteViewController.quote = updateQuoteText
            updateQuoteViewController.person = updatePersonText
            updateQuoteViewController.PK = updatePK
        } else if segue.identifier == "AddQuotesSegue" {
            let addQuoteViewController = segue.destination as! AddQuotesViewController
        }
        
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        self.quotesTableView.reloadData()
        refreshControl.endRefreshing()
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuotesViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)

        return refreshControl
    }()

    @objc func loadList(){
        //load data here
        self.quotesTableView.reloadData()
    }

//    MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        cell.textLabel?.text = quotesArray[indexPath.row].Quote
        cell.detailTextLabel?.text = quotesArray[indexPath.row].Person

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredQuotes.count
        }
        return quotesArray.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let text : String!
            
            if self.isSearching {
               text = self.filteredQuotes[indexPath.row].Person
            }
            
            let primaryKey = quotesArray[indexPath.row].PK
            let DeleteQuote_URL = Quotes_URL + String(primaryKey)
            
            self.deleteQuote(url: DeleteQuote_URL)
            
            quotesArray.remove(at: Int(indexPath.row))
            let indexPath = IndexPath(item: 0, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)

            self.quotesTableView.reloadData()
        }
        
        func searchBar(_ quotesSearchBar : UISearchBar, textDidChange: String) {
            if quotesSearchBar.text == nil || quotesSearchBar.text == "" {
                isSearching = false
                view.endEditing(true)
                quotesTableView.reloadData()
            } else {
                isSearching = true
                filteredQuotes = quotesArray.filter({$0.Person == quotesSearchBar.text!})
                quotesTableView.reloadData()
            }
        }
        
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
        
            self.performSegue(withIdentifier: "updateQuoteSegue", sender: self)
            self.updatePersonText = quotesArray[indexPath.row].Person
            self.updateQuoteText = quotesArray[indexPath.row].Quote
            self.updatePK = quotesArray[indexPath.row].PK
            
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
                    
                    quotesArray.append(quote)
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
