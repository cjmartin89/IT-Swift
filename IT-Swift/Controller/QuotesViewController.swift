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

    //Instance Variables
    
    var filteredQuotes = [Quote]()
    var isSearching = false
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
        quotesSearchBar.delegate = self
        quotesSearchBar.returnKeyType = UIReturnKeyType.done

        retrieveQuotes(url: "https://calm-savannah-82295.herokuapp.com/quotes/")

        self.quotesTableView.addSubview(self.refreshControl)
        
        quotesTableView.tableFooterView = UIView()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateQuoteSegue" {
            let updateQuoteViewController = segue.destination as! UpdateQuoteViewController
            if let indexPath = self.quotesTableView.indexPathForSelectedRow {
                updateQuoteViewController.person = quotesArray[indexPath.row].person
                updateQuoteViewController.quote = quotesArray[indexPath.row].quote
            updateQuoteViewController.PK = quotesArray[indexPath.row].PK
            }
        }
        
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        self.quotesTableView.reloadData()
        refreshControl.endRefreshing()
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuotesViewController.handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)

        return refreshControl
    }()

    @objc func loadList(){
        //load data here
        self.quotesTableView.reloadData()
    }

//    MARK: - TableView DataSource Methods
// Check here for search issues
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text : String!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        if self.isSearching {
            //            text = self.filteredQuotes[indexPath.row].Person
            cell.textLabel?.text = self.filteredQuotes[indexPath.row].quote
            cell.detailTextLabel?.text = self.filteredQuotes[indexPath.row].person
        } else {
            cell.textLabel?.text = quotesArray[indexPath.row].quote
            cell.detailTextLabel?.text = quotesArray[indexPath.row].person
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredQuotes.count
        }
        
        return quotesArray.count
    }
    
    //Set up cell context actions
    
    //Set up delete action
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            let primaryKey = quotesArray[indexPath.row].PK
            let DeleteQuote_URL = Quotes_URL + String(primaryKey)
            
            self.deleteQuote(url: DeleteQuote_URL)
            
            quotesArray.remove(at: Int(indexPath.row))
            let indexPath = IndexPath(item: 0, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)

            self.quotesTableView.reloadData()
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "updateQuoteSegue", sender: self)
        quotesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBar(_ quotesSearchBar : UISearchBar, textDidChange: String) {
        if quotesSearchBar.text == nil || quotesSearchBar.text == "" {
            isSearching = false
            quotesTableView.reloadData()
        } else {
            isSearching = true
            self.quotesSearchBar.showsCancelButton = true
            let lower = quotesSearchBar.text!.lowercased()
            filteredQuotes = quotesArray.filter({$0.person.lowercased().hasPrefix(lower)})
            quotesTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        quotesSearchBar.resignFirstResponder() // hides the keyboard.
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
        retrieveQuotes(url: "http://18.220.140.97:8080/api/quotes/")
        quotesSearchBar.resignFirstResponder()
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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

                for (_, _) in quotesJSON {
                    let quoteResult = quotesJSON[self.quoteIndex]["quote"].stringValue
                    let personResult = quotesJSON[self.quoteIndex]["person"].stringValue
                    let pkResult = quotesJSON[self.quoteIndex]["pk"].intValue

                    let quote = Quote()
                    quote.person = personResult
                    quote.quote = quoteResult
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
