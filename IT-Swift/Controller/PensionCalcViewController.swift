//
//  PensionCalcViewController.swift
//  IT-Swift
//
//  Created by Chris Martin on 12/11/17.
//  Copyright © 2017 Martin Technical Solutions. All rights reserved.
//

import UIKit

class PensionCalcViewController: UIViewController, UITextFieldDelegate {

    var shortestTime : Int = 0
    var formattedFutureSalary : String = ""
    var earningsArray : [Double] = []
    
    @IBOutlet weak var ageInputTextField: UITextField!
    @IBOutlet weak var yearsOfServiceTextField: UITextField!
    @IBOutlet weak var retYearResult: UILabel!
    @IBOutlet weak var retSalaryResult: UILabel!
    
    @IBOutlet weak var salaryTextField: UITextField!
    
    @IBOutlet weak var finalEarningsResult: UILabel!
    @IBOutlet weak var retirementAgeResult: UILabel!
    @IBOutlet weak var yearsToRetirementTextField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ageInputTextField.delegate = self
        self.yearsOfServiceTextField.delegate = self
        self.salaryTextField.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        retYearResult.text = calcRetYear()
        calcFutureSalary()
        retSalaryResult.text = calcRetEarnings()
        finalEarningsResult.text = formatCurrencyValue(numberToFormat: calcFAE())
        retirementAgeResult.text = "\(calcRetAge())"
        yearsToRetirementTextField.text = "You may retire in : \(shortestTime) years"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func calcRetYear() -> String {
        
        let age = Int(ageInputTextField.text!)
        let yearsOfService = Int(yearsOfServiceTextField.text!)
        
        var dateComponents = DateComponents()
        let currentDate = Date()
        
        let timeToRetAge : Int = 62 - age!
        let timeToRetService : Int = 30 - yearsOfService!
        
        shortestTime = min(timeToRetAge, timeToRetService)
        dateComponents.year = shortestTime
        
        let retYear = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        let dateString = formatter.string(from: retYear!)
        
        return dateString
    }
    
    func percentEarnings() -> Double {
        
        let yearsOfService = shortestTime
        let percentEarnings : Double = Double(yearsOfService) * 2.5
        
        return percentEarnings / 100
    }
    
    func calcFutureSalary() {
        let years = shortestTime
        print(shortestTime)
        var calcFutureEarnings : Double = Double(salaryTextField.text!)!
        print(calcFutureEarnings)
        var i = 0
        while i < years {
            calcFutureEarnings = calcFutureEarnings + (calcFutureEarnings * 2.0 / 100)
            earningsArray.append(calcFutureEarnings)
            i = i + 1
        }
        print(earningsArray)
    }
    
    func calcRetEarnings() -> String{
        
        let salary = calcFAE()
        print("Salary is: \(salary)")
        let retEarnings : Double = salary * percentEarnings()
        print(retEarnings)

        return formatCurrencyValue(numberToFormat: retEarnings)
    }
    
    func calcRetAge() -> Int{
        
        let age = Int(ageInputTextField.text!)
        let retAge = age! + shortestTime
        
        return retAge
    }
    
    func calcFAE() -> Double {
        
        var FAE = 0.0
        let range = earningsArray.index(earningsArray.endIndex, offsetBy: -5) ..< earningsArray.endIndex
        let arraySlice = earningsArray[range]
        
        let sumArray = arraySlice.reduce(0, +)
        FAE = sumArray / Double(arraySlice.count)
        print(FAE)
        
        return FAE
    }
    
    func formatCurrencyValue(numberToFormat : Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        let formattedNumber = formatter.string(from: NSNumber(value: numberToFormat))
        return formattedNumber!
        
    }
    
}
